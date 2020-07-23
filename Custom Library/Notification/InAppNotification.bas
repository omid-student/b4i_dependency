B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
#Event: Click(Tag As Object)

Private Sub Class_Globals
	Private page As Page
	Private play_sound As Boolean
	Private tag_ As Object
	Private pnl As Panel
	Private lbl,lbltitle As Label
	Private image_view,mini_image_view As ImageView
	Private duration_val As Int
	Private delay_val As Int
	Private is_open As Boolean
	Private module_ As Object
	Private event_ As String
	Private sound_code As Int
	Private tmr As Timer
	Private datetime_ As Long
	Private lbltime As Label
	Private auto_hide As Boolean
	Private medi As MediaPlayer
End Sub

'if you set NotificationType to 1,only show text and icon
'if you set NotificationType to 2,notification contain time,app title and subject
Public Sub Initialize(Page1 As Page,Module As Object,Event As String,NotificationType As Int)
	
	page			=	Page1
	
	module_			=	Module
	event_			=	Event
	
	pnl.Initialize("pnlitem")
	
	If NotificationType = 2 Then
		Page1.RootPanel.AddView(pnl,10dip,-100dip,Page1.RootPanel.Width - 20dip,100dip)
	Else
		Page1.RootPanel.AddView(pnl,10dip,-100dip,Page1.RootPanel.Width - 20dip,80dip)
	End If
	
	pnl.SetBorder(0,Colors.Transparent,9dip)
	pnl.Color	=	Colors.RGB(253,253,253)
	pnl.SetShadow(Colors.ARGB(80,0,0,0),1dip,1dip,1,False)
	
	If NotificationType = 2 Then
		
		mini_image_view.Initialize("pnlitem")
		pnl.AddView(mini_image_view,9dip,9dip,20dip,20dip)
		mini_image_view.SetBorder(0,Colors.Transparent,4dip)

		Dim lblapp_title As Label
		lblapp_title.Initialize("pnlitem")
		lblapp_title.Text			=	GetAppName.ToUpperCase
		lblapp_title.TextAlignment	=	lblapp_title.ALIGNMENT_LEFT
		lblapp_title.Font			=	Font.CreateNew(12)
		lblapp_title.TextColor		=	Colors.Gray
		pnl.AddView(lblapp_title,37dip,11dip,pnl.Width - 140dip,17dip)
		
		lbltime.Initialize("pnlitem")
		lbltime.TextAlignment		=	lblapp_title.ALIGNMENT_RIGHT
		lbltime.Font				=	Font.CreateNew(12)
		lbltime.TextColor			=	Colors.Gray
		pnl.AddView(lbltime,lblapp_title.Width + lblapp_title.Left,lblapp_title.Top,95dip,17dip)
	
		lbltitle.Initialize("pnlitem")
		lbltitle.TextAlignment		=	lblapp_title.ALIGNMENT_RIGHT
		lbltitle.Font				=	Font.CreateNewBold(13)
		lbltitle.TextColor			=	Colors.Black
		pnl.AddView(lbltitle,mini_image_view.Left,lblapp_title.Height + 24dip,pnl.Width - 22dip,10dip)
		
		lbl.Initialize("pnlitem")
		lbl.TextAlignment			=	lbl.ALIGNMENT_RIGHT
		lbl.Font					=	Font.CreateNew(13)
		lbl.Multiline				=	True
		pnl.AddView(lbl,lbltitle.Left,lbltitle.Height + lbltitle.Top + 2dip,lbltitle.Width-lbltitle.Left,40dip)
		
	Else
		
		image_view.Initialize("pnlitem")
		pnl.AddView(image_view,10dip,0,53dip,53dip)
		image_view.SetBorder(0,Colors.Transparent,image_view.Height/2)
		CenterViewTop(image_view,pnl)
		
		lbl.Initialize("pnlitem")
		lbl.TextAlignment			=	lbl.ALIGNMENT_LEFT
		lbl.Font					=	Font.CreateNew(13)
		lbl.Multiline				=	True
		pnl.AddView(lbl,image_view.Width + image_view.Left + 10dip,10dip,pnl.Width - (image_view.Width + image_view.Left + 10dip),50dip)
		CenterViewTop(lbl,pnl)
		
	End If
	
	duration_val	=	1500
	delay_val		=	2500
	sound_code		=	1000
	
	tmr.Initialize("tmr",delay_val)
	
End Sub

Private Sub pnlitem_Click
	
	is_open	=	False
	tmr.Enabled = False
	
	pnl.SetLayoutAnimated(duration_val,1,pnl.Left,-150dip,pnl.Width,pnl.Height)
	
	If SubExists(module_,event_ & "_click",1) Then
		CallSub2(module_,event_ & "_click",tag_)
	End If
	
End Sub

Public Sub Cancel
	
	is_open	=	False
	tmr.Enabled = False
	
	pnl.SetLayoutAnimated(duration_val,1,pnl.Left,-150dip,pnl.Width,pnl.Height)
	
End Sub

'1000 	new-mail
'1001 	mail-sent
'1002 	Voicemail
'1003 	ReceivedMessage
'1004 	SentMessage
'1005 	alarm
'1006 	low_power
'1007 	sms-received1
'1008 	sms-received2
'1009 	sms-received3
'1010 	sms-received4	
'1011 	SMSReceived_Vibrate 	
'1012 	sms-received1
'1013 	sms-received5
'1014 	sms-received6
'1015 	Voicemail
'1016 	tweet_sent
'1020 	Anticipate
'1021 	Bloom
'1022 	Calypso
'1023 	Choo_Choo
'1024 	Descent
'1025 	Fanfare
'1026 	Ladder
'1027 	Minuet
'1028 	News_Flash
'1029 	Noir
'1030 	Sherwood_Forest
'1031 	Spell
'1032 	Suspense
'1033 	Telegraph
'1034 	Tiptoes
'1035 	Typewriters
'1036 	Update
'1050 	ussd
'1051 	SIMToolkitCallDropped
'1052 	SIMToolkitGeneralBeep
'1053 	SIMToolkitNegativeACK
'1054 	SIMToolkitPositiveACK
'1055 	SIMToolkitSMS
'1057 	Tink
'1070 	ct-busy
'1071 	ct-congestion
'1072 	ct-path-ack
'1073 	ct-error
'1074 	ct-call-waiting
'1075 	ct-keytone2
'1100 	lock
'1101 	unlock
'1102 	FailedUnlock 	
'1103 	Tink
'1104 	Tock
'1105 	Tock
'1106 	beep-beep
'1107 	RingerChanged
'1108 	photoShutter
'1109 	shake
'1110 	jbl_begin
'1111 	jbl_confirm
'1112 	jbl_cancel
'1113 	begin_record
'1114 	end_record
'1115 	jbl_ambiguous
'1116 	jbl_no_match
'1117 	begin_video_record
'1118 	end_video_record
'1150 	vc~invitation-accepted
'1151 	vc~ringing
'1152 	vc~ended
'1153 	ct-call-waiting
'1154 	vc~ringing
'1200 	TouchTone 	
'1201 	TouchTone 	
'1202 	TouchTone 	
'1203 	TouchTone 	
'1204 	TouchTone 	
'1205 	TouchTone 	
'1206 	TouchTone 	
'1207 	TouchTone 	
'1208 	TouchTone 	
'1209 	TouchTone 	
'1210 	dtmf-star
'1211 	dtmf-pound
'1254 	long_low_short_high
'1255 	short_double_high
'1256 	short_low_high
'1257 	short_double_low
'1258 	short_double_low
'1259 	middle_9_short_double_low
'1300 	Voicemail
'1301 	ReceivedMessage
'1302 	new-mail
'1303 	mail-sent
'1304 	alarm
'1305 	lock
'1306 	Tock
'1307 	sms-received1
'1308 	sms-received2
'1309 	sms-received3
'1310 	sms-received4
'1311 	SMSReceived_Vibrate 	
'1312 	sms-received1	
'1313 	sms-received5
'1314 	sms-received6
'1315 	Voicemail
'1320 	Anticipate
'1321 	Bloom
'1322 	Calypso
'1323 	Choo_Choo
'1324 	Descent
'1325 	Fanfare
'1326 	Ladder
'1327 	Minuet
'1328 	News_Flash
'1329 	Noir
'1330 	Sherwood Forest
'1331 	Spell
'1332 	Suspense
'1333 	Telegraph
'1334 	Tiptoes
'1335 	Typewriters
'1336 	Update
'1350
'1351	
'4095
Public Sub setSoundID(ID As Int)
	sound_code	=	ID
End Sub

'from asset
Public Sub setSoundName(Filename As String)
	medi.Initialize(File.DirAssets,Filename,"")
End Sub

'get notification label
Public Sub getLabel As Label
	Return lbl
End Sub

'get notification icon
Public Sub getImageView As ImageView
	Return image_view
End Sub

Public Sub setAlertBody(Text As String)
	
	If lbl.IsInitialized Then
		lbl.Text		=	Text
	Else
		
	End If
	
End Sub

Public Sub setTitle(Text As String)
	
	If lbltitle.IsInitialized Then
		lbltitle.Text		=	Text
	Else
		
	End If
	
End Sub

Public Sub setDateTime(Val As Long)
	datetime_	=	Val
End Sub

'set animation duration
'measure second
Public Sub setDuration(Val As Int)
	duration_val	=	Val * 1000
End Sub

'set notification delay
'measure second
Public Sub setDelay(Val As Int)
	delay_val		=	Val * 1000
	tmr.Interval	=	delay_val
End Sub

Public Sub setPlaySound(Val As Boolean)
	play_sound		=	Val
End Sub

Public Sub setTag(Tag As Object)
	tag_			=	Tag
End Sub

Public Sub getTag As Object
	Return tag_
End Sub

Public Sub setIcon(Icon As Bitmap)
	
	If image_view.IsInitialized Then
		image_view.Bitmap	=	Icon
	End If
	
	If mini_image_view.IsInitialized Then
		mini_image_view.Bitmap	=	Icon
	End If
	
End Sub

Public Sub Register
	
	If datetime_ = 0 Then
		datetime_	=	DateTime.Now
	End If
	
	If lbltime.IsInitialized Then
		lbltime.Text	=	GetTimeAgo(datetime_)
	End If
	
	If is_open Then Return
	
	If play_sound Then
		If medi.IsInitialized Then
			medi.Play
		Else
			PlayNotification(sound_code)
		End If
	End If
	
	is_open	=	True
	pnl.SetLayoutAnimated(duration_val,1,pnl.Left,10dip,pnl.Width,pnl.Height)
		
	If is_open = False Then Return
	
	If auto_hide Then
		tmr.Enabled = True
		Wait For tmr_Tick
			tmr.Enabled = False
			pnl.SetLayoutAnimated(duration_val,1,pnl.Left,-150dip,pnl.Width,pnl.Height)
			is_open	=	False
			
	End If
	
End Sub

Public Sub setAutoHide(Val As Boolean)
	auto_hide	=	Val
End Sub

#Region Private

Private Sub CenterViewTop(v As View, parent As View)
	v.Top = parent.Height / 2 - v.Height / 2
End Sub

Private Sub PlayNotification (id As Int)
	Dim no As NativeObject = Me
	no.RunMethod("playNotification:", Array(id))
End Sub
'#if objc
'- (void)playNotification:(int)soundId {
'   AudioServicesPlaySystemSound(soundId);
'}
'#end if

Private Sub GetAppName As String
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleDisplayName"))
	Return name
End Sub

Public Sub GetTimeAgo(Time As String) As String
	
	If IsNumber(Time) = False Then
	
		Dim p(),sDate(),sTime() As String
		p = Regex.Split(" ",Time)
		
		If Time.IndexOf("-") > -1 Then
			sDate = Regex.Split("-",p(0))
			sTime = Regex.Split(":",p(1))
		Else if Time.IndexOf("/") > -1 Then
			sDate = Regex.Split("/",p(0))
			sTime = Regex.Split(":",p(1))
		Else if Time.IndexOf("\") > -1 Then
			sDate = Regex.Split("\",p(0))
			sTime = Regex.Split(":",p(1))
		End If
		
		Time = SetDateAndTime(sDate(0),sDate(1),sDate(2),sTime(0),sTime(1),sTime(2))
		
	End If
	
	Dim diff As Long
	diff = DateTime.Now - Time

	Dim seconds,minutes,days,years,hours As Double
	seconds = Abs(diff) / 1000
	minutes = seconds / 60
	hours = minutes / 60
	days = hours / 24
	years = days / 365

	Dim words As String

	If seconds < 45 Then
		words = "Moments ago"
		
	Else if seconds < 90 Then
		words = "A minute ago"
		
	Else if (minutes < 45) Then
		words = Round(minutes) & " minute ago"
		
	Else if minutes < 90 Then
		words = "An hour ago"
		
	Else if hours < 24 Then
		words = Round(hours) & " hour ago"
		
	Else if hours < 42 Then
		words = "A day ago"
		
	Else if days < 30 Then
		words = Round(days) & " day ago"
		
	Else if days < 45 Then
		words = "One month ago"
		
	Else if days < 365 Then
		words = Round(days / 30) & " month ago"
		
	Else if years < 1.5 Then
		words = "A year ago"
		
	Else
		words = Round(years) & " year ago"
		
	End If

	Return words

End Sub

Private Sub SetDateAndTime(Years As Int, Months As Int, Days As Int, Hours As Int, Minutes As Int, Seconds As Int) As Long
	Dim df = DateTime.DateFormat, tf = DateTime.TimeFormat As String
	DateTime.DateFormat = "GGyyyyMMdd"
	DateTime.TimeFormat = "HHmmss"
	Dim d As String = Format(Abs(Years), 4) & Format(Months, 2) & Format(Days, 2)
	d = GetEra(Years < 0) & d
	Dim t As String = Format(Hours, 2) & Format(Minutes, 2) & Format(Seconds, 2)
	Try
		Dim ticks As Long = DateTime.DateTimeParse(d, t)
	Catch
		DateTime.DateFormat = df
		DateTime.TimeFormat = tf
		Log("Error: Invalid value: " & d & " " & t)
		Return "invalid date" + 1 'hack to throw an error
	End Try
	DateTime.DateFormat = df
	DateTime.TimeFormat = tf
	Return ticks
End Sub

Private Sub Format(Value As Int, Length As Int) As String
	Return NumberFormat2(Value, Length, 0, 0, False)
End Sub

Private Sub GetEra(Negative As Boolean) As String
	Private ad, bc As String
	Dim df As String = DateTime.DateFormat
	If Negative Then
		If bc <> "" Then Return bc
		DateTime.DateFormat = "GG"
		bc = DateTime.Date(-137628808000000)
		DateTime.DateFormat = df
		Return bc
	Else
		If ad <> "" Then Return ad
		DateTime.DateFormat = "GG"
		ad = DateTime.Date(0)
		DateTime.DateFormat = df
		Return ad
	End If
End Sub
#End Region