B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
Private Sub Class_Globals
	Private admob2 As AdView
	Private Page1 As Page
	Private AppID As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Page As Page)
	Page1	=	Page
End Sub

Public Sub SetAppID(Key As String)
	AppID	=	Key
End Sub

Public Sub AddBannerBottom
	
	admob2.Initialize("admob",AppID,Page1,admob2.SIZE_BANNER)
	#if debug
	admob2.SetTestDevices(Array("d23012706d4104200b0723f711ab134f"))
	#End If
	admob2.LoadAd

End Sub

Private Sub admob_ReceiveAd
	Page1.RootPanel.AddView(admob2,0,Page1.RootPanel.Height - 50dip,Page1.RootPanel.Width,50dip)
	admob2.BringToFront
	Log("revieve admob")
End Sub

Private Sub admob_FailedToReceiveAd (ErrorCode As String)
	Log("fail receive admob")
End Sub