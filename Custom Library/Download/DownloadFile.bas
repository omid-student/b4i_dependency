B4i=true
Group=Libaries
ModulesStructureVersion=1
Type=Class
Version=4.81
@EndOfDesignText@
#Event: Complete
#Event: Complete(Result As String)
#Event: Error(Message As String)
#Event: Cancel
#Event: Progress(Progress As Float,Total As Float)
#Event: Error(Error As String)

Private Sub Class_Globals
	Private mo As Object
	Private evt As String
	Private tag_ As Object
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Module As Object,Event As String)
	mo	= Module
	evt = Event.ToLowerCase
End Sub

Public Sub AddHeader(Key As String,Val As String)
	
End Sub

Public Sub setTag(Value As Object)
	tag_	=	Value	
End Sub

Public Sub getTag As Object
	Return tag_
End Sub

Private Sub Download_Complete
	
	If File.Exists(File.DirTemp,"temp.txt") Then
		If SubExists(mo,evt & "_complete",1) Then
			CallSub2(mo,evt & "_complete",File.ReadString(File.DirTemp,"temp.txt"))
		End If
		Return
	End If
	
	If SubExists(mo,evt & "_complete",0) Then
		CallSub(mo,evt & "_complete")
	End If
	
End Sub

Private Sub Download_Progress(ProgressValue As String,Total As String)
	Dim val,Total2 As Float
	val 	= 	ProgressValue
	Total2	=	Total
	If SubExists(mo,evt & "_progress",2) Then CallSub3(mo,evt & "_progress",val,Total2)
End Sub

Private Sub Download_Error(ErrorMessage As String)
	If SubExists(mo,evt & "_error",1) Then CallSubDelayed2(mo,evt & "_error",ErrorMessage)
End Sub

'FileDir and FileName is path for save file
Sub Download(Url As String,OutoutFileDir As String,OutoutFileName As String,Headers As Map)
	
	Dim Keys,Values As List
	Keys.Initialize
	Values.Initialize
	
	If Headers <> Null Then
		For Each Key As String In Headers.Keys
			Keys.Add(Key)
		Next
		
		For Each Val As String In Headers.Values
			Values.Add(Val)
		Next
	End If
	
	Dim NativeMe As NativeObject = Me
	NativeMe.RunMethod("Download::::::",Array(Url,Null,OutoutFileDir & "/" & OutoutFileName,"",Keys,Values))
	
End Sub

'download and return string only without save it
Sub Download2(Url As String,Headers As Map)
	
	Dim Keys,Values As List
	Keys.Initialize
	Values.Initialize
	
	If Headers <> Null Then
		For Each Key As String In Headers.Keys
			Keys.Add(Key)
		Next
		
		For Each Val As String In Headers.Values
			Values.Add(Val)
		Next
	End If
	
	Dim NativeMe As NativeObject = Me
	NativeMe.RunMethod("Download::::::",Array(Url,Null,File.DirTemp,"temp.txt",Keys,Values))
	
End Sub

#IgnoreWarnings:12
Sub Cancel
	
	Dim NativeMe As NativeObject = Me
	NativeMe.RunMethod("cancel:", Array (True))
	
	If SubExists(mo,evt & "_cancel",0) Then
		CallSub(mo,evt & "_cancel")
	End If
	
End Sub

#If OBJC

NSURLResponse *DownloadedResponse;
NSMutableData *DownloadedData;
NSString *FilePath;
NSURLConnection * connection2;
NSURLRequest *request;

- (void) cancel: (bool) on {
	[connection2 cancel];
}

-(void)Download: (NSString *)FileUrl :(UILabel *)LabelToSet :(NSString *)Directory :(NSString *)FileName :(NSArray *)Headers :(NSArray *)Values
{

	FilePath = [Directory stringByAppendingString: FileName];

	DownloadedData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString:FileUrl];
	request = [NSURLRequest requestWithURL:url];
	NSMutableURLRequest *mutableRequest = [request mutableCopy];

	NSUInteger count = [Headers count];
	for (NSUInteger i = 0; i < count; i++) {
		NSString * key = [Headers objectAtIndex: i];
   		NSString * val = [Values objectAtIndex: i];
		[mutableRequest addValue:val forHTTPHeaderField:key];
	}
	 
	request = [mutableRequest copy];
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	connection2	=	connection;
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   [DownloadedData appendData:data];
   float res = ((100.0/DownloadedResponse.expectedContentLength)*DownloadedData.length)/100;

   NSString * LabelText = [NSString stringWithFormat:@"%f", (res)];
   NSString * LabelText2 = [NSString stringWithFormat:@"%d", [DownloadedData length]];
   
   [self.bi raiseEvent:nil event:@"download_progress::" params:@[(LabelText),LabelText2]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   [DownloadedData writeToFile:FilePath atomically:YES];
   [self.bi raiseEvent:nil event:@"download_complete" params:@[]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   [self.bi raiseEvent:nil event:@"download_error:" params:@[error.localizedDescription]];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  DownloadedResponse = response;
}
#End If