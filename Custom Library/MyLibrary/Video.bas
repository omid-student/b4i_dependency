B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=5.3
@EndOfDesignText@
'Code module

Private Sub Process_Globals

End Sub

Sub FullScreen(VideoView1 As VideoPlayer,Status As Boolean)
	
	Dim no As NativeObject = VideoView1
	no = no.GetField("player").GetField("moviePlayer")
	no.SetField("fullscreen", Status)
	
End Sub

Sub ScaleMode(VideoView1 As VideoPlayer,Scale As Int)
	
	Dim no As NativeObject = VideoView1
	no = no.GetField("player").GetField("moviePlayer")
	no.SetField("scalingMode", Scale)
	
End Sub

Sub GetBaseView(vp As VideoPlayer) As Panel
	Dim no As NativeObject = vp
	Return no.GetField("controller").GetField("view").GetField("superview")
End Sub