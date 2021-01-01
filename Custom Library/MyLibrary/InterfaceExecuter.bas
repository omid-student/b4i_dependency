B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.81
@EndOfDesignText@
'Code module

Sub Process_Globals
	Public StoreData	As Map
End Sub

'Add below field to Map
'dir 		: for save file in directory
'filename	: for save file with filename
'url		: url of file for download
'store		: save output in cache
#IgnoreWarnings: 19
Public Sub Download(Fields As Map)

	Try
		Dim OutputDir,OutputFilename,Url As String
		
		OutputDir		=	Fields.Get("dir")
		OutputFilename	=	Fields.Get("filename")
		Url				=	Fields.Get("url")
		
		Dim tags As Map
		tags.Initialize
		tags.Put("dir",OutputDir)
		tags.Put("filename",OutputFilename)
		tags.Put("url",Url)
		tags.Put("module",Fields.Get("module"))
		tags.Put("event",Fields.Get("event"))
		
		If Fields.ContainsKey("store") Then
			tags.Put("store",Fields.Get("store"))
		End If
		
		Dim job As HttpJob
		job.Initialize("download",Me)
		job.Download(Url)
		job.Tag		=	tags
		job.GetRequest.SetHeader("Cache-Control","no-store, no-cache, must-revalidate, max-age=0")
		job.GetRequest.Timeout	=	50000

	Catch
	End Try
		
End Sub

'Arg contain below key
'Method  : Type of Request(POST,PUT,DELETE,GET) 
'Segment : Name of method that have to execute
'Fields  : Key of query that have to send to Segment
'Module  : The module that call this event
'Event   : Event name that interface have to call it
'Force   : If it exist so save request and resend it again after connected internet
'
'If method is FILE so we have to add FileItem to list example here
'Dim ft As MultipartFileData
'ft.Initialize
'ft.KeyName		= "upload"
'ft.Dir			= FileDir
'ft.FileName	= FileName
'
'Dim lst as List
'lst.Initialize
'lst.Add(ft)

Public Sub ExecuteRequest(Arg As Map,Headers As Map)
	
	Main.App.NetworkActivityIndicatorVisible = True
	
	Dim Method,Segment,Url As String
	Dim Fields As Map
	
	Method 	= Arg.Get("method")
	Segment	= Arg.Get("segment")
	Fields	= Arg.Get("fields")
	
	If Arg.ContainsKey("url") Then
		Url	=	Arg.Get("url")
	Else
		Url		= Configuration.URL_ & Segment
	End If
	
	Dim job As HttpJob
	job.Initialize("request",Me)
	job.Tag	=	Arg
	
	#region Add Field to body
	Dim query As String
	
	If Fields <> Null And Fields.IsInitialized And Fields.Size > 0 Then
		For Each v1 As String In Fields.Keys
			query = query & v1 & "=" & Fields.Get(v1) & "&"
		Next
		query = query.SubString2(0,query.Length-1)
	End If
	#end region
	
	#region Detect Method(POST,DELETE or ...)
	If Method = "POST" Then
		job.PostString(Url,query)
		
	Else If Method = "PUT" Then
		job.PostString(Configuration.URL_ & Segment,"")
		job.GetRequest.InitializePut2(Url,query.GetBytes("UTF8"))
	
	Else If Method = "DELETE" Then
		job.PostString(Configuration.URL_ & Segment,query)
		job.PostBytes(Configuration.URL_ & Segment, query.GetBytes("utf8"))
		Dim no As NativeObject = job.GetRequest
		no.GetField("object").RunMethod("setHTTPMethod:", Array("DELETE"))
	
	Else If Method = "GET" Then
		job.Download(Url & "?" & query)
	
	Else If Method = "FILE" Then
		Dim ListFiles As List
		ListFiles	=	Arg.Get("files")
		
		job.PostMultipart(Url,Fields,ListFiles)
		job.GetRequest.Timeout = 40000
	
	End If
	#end region
	
	#region Add Headers
	job.GetRequest.SetHeader("Cache-Control","no-store, no-cache, must-revalidate, max-age=0")
	job.GetRequest.SetHeader("vc",Application.VersionCode)
	job.GetRequest.SetHeader("vn",Application.VersionName)
	job.GetRequest.SetHeader("pn",Application.PackageName)
	job.GetRequest.SetHeader("os","ios")
	
	If job.GetRequest.Timeout <> 40000 Then
		job.GetRequest.Timeout = 16000
	End If
	
	For Each Key As String In Headers.Keys
		job.GetRequest.SetHeader(Key,Headers.Get(Key))
	Next
	#end region
	
End Sub

Private Sub JobDone(HttpJob2 As HttpJob)

	Main.App.NetworkActivityIndicatorVisible = False
	
	Try
		
		Dim Modules As Object
		Dim Evt As String
		Dim tag As Map
		
		tag = HttpJob2.Tag
		Modules	=	tag.Get("module")
		Evt		=	tag.Get("event") & "_result"
		
		If HttpJob2.Success Then

			If HttpJob2.JobName = "request" Then
				
				#if debug
				Log(HttpJob2.GetString)
				#End If
				
				#region Request Job	
				Dim rs As String
				rs = HttpJob2.GetString.Trim
				rs = rs.Replace("</div>","")
				
				Dim js As JSONParser
				js.Initialize(rs)
				
				Try
					Dim temp As Map
					temp = js.NextObject
					
					Dim temp2 As Map
					temp2.Initialize
					
					If SubExists(Modules,Evt,2) Then
						CallSub3(Modules,Evt,temp,temp.Get("status"))
					End If
					HttpJob2.Release
					Return
					
				Catch
					If SubExists(Modules,Evt,2) Then
						CallSub3(Modules,Evt,CreateMap("code":"0"),False)
					End If
					HttpJob2.Release
					Return
				End Try
				
				#end region
				
			Else if HttpJob2.JobName = "download" Then

				#region Download File
				
				If tag.ContainsKey("store") Then
					If StoreData.IsInitialized = False Then StoreData.Initialize
					StoreData.Put(tag.Get("store"),Json2Map(HttpJob2.GetString))
					If SubExists(Modules,Evt,0) Then
						CallSub(Modules,Evt)
					End If
				Else
					Dim ou As OutputStream
					ou	=	File.OpenOutput(tag.Get("dir"),tag.Get("filename"),False)
					File.Copy2(HttpJob2.GetInputStream,ou)
					ou.Close
					If SubExists(Modules,Evt,0) Then
						CallSub(Modules,Evt)
					End If
				End If
				
				#end region
				
			End If
		Else
			
			#region Manage error job
			
			Log(tag)
			
			Dim error As Map
			error.Initialize
			
			Dim job_error As String
			job_error = HttpJob2.ErrorMessage.ToLowerCase
			
			If job_error.IndexOf("ResponseError. Reason: Service unavailable, Response: Service unavailable".ToLowerCase) > -1 Then
				error.Put("error","SERVICE_UNAVAIALBE")
			
			Else if job_error.IndexOf("java.net.UnknownHostException: Unable to resolve host".ToLowerCase) > -1 Then
				error.Put("error","HOST_UNAVAILABLE")
			
			Else if job_error.IndexOf("java.net.SocketTimeoutException".ToLowerCase) > -1 Then
				error.Put("error","NETWORK_ERROR")
				
			Else if job_error.IndexOf("ResponseError. Reason: java.net.ConnectException: Failed To connect".ToLowerCase) > -1 Then
				error.Put("error","ERROR_CONNECT")
			
			Else if job_error.IndexOf("android.os.NetworkOnMainThreadException".ToLowerCase) > -1 Then
				error.Put("error","ERROR_MAIN_THREAD")
			
			Else if job_error.IndexOf("java.net.connectexception: failed to connect to") > -1 Then
				error.Put("error","NOT_EXIST_HOST")
				
			Else
				error.Put("error",job_error)
				
			End If
			
			If SubExists(Modules,"JobError",1) Then
				error.Put("event",Evt)
				CallSubDelayed2(Modules,"JobError",error)
			End If
			
			#end region
			
		End If
		
		HttpJob2.Release
		
	Catch
		Try
			If Modules = Null Then Return
			If SubExists(Modules,Evt,2) Then
				CallSub3(Modules,Evt,CreateMap("code":"0"),False)
			End If
		Catch
			HttpJob2.Release
		End Try
	End Try
	
	HttpJob2.Release
	
End Sub

Private Sub Json2Map(JSON_ As String) As Map
	
	Try
		Dim js As JSONParser
		js.Initialize(JSON_)
		Return js.NextObject
	Catch
		Return Null
	End Try
	
End Sub

Private Sub SetImageToView(View1 As View,Bitmap2 As Bitmap)
	
	If View1 Is ImageView Then
		Dim img As ImageView
		img = View1
		img.Bitmap		= Bitmap2
			
	Else If View1 Is Panel Then
		Dim pnl As Panel
		pnl= View1
		
		Dim img As ImageView
		img.Initialize("")
		pnl.AddView(img,0,0,pnl.Width,pnl.Height)
		img.ContentMode = img.MODE_FILL
		img.Bitmap = Bitmap2
			
	End If
	
End Sub

#IgnoreWarnings: 12
#IgnoreWarnings: 2
Private Sub SaveBitmap(bitmap1 As Bitmap,Dir As String,Filename As String,Format As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = bitmap1
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,Format)
	out.Close
End Sub

'get filename of fullpath
Private Sub GetFilename(fullpath As String) As String
	Try
		Dim index As Int
		index = fullpath.LastIndexOf("/")
		Dim rs As String
		rs = fullpath.SubString(index + 1)
		Return rs
	Catch
		
	End Try
End Sub