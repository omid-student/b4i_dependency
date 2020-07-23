B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.01
@EndOfDesignText@
#Event: AnimationComplete(State As Boolean)

Private Sub Class_Globals

	Private SlidingPanel As Panel
	Private downY As Int
	Private ACTION_UP, ACTION_DOWN, ACTION_MOVE As Int

	Private IsSheetOpen As Boolean

	Private cCallback As Object
	Private cEventName As String
	
	Private Me_parent As Panel
	
	Private Bar_Height As Int

End Sub

'parent is panel that we add LayoutContainer to it
'BarHeight is bar's height that placed in bottom page
'LayoutContainer is panel that contain your views when user drag it
'The first view of LayoutContainer is selected for default bar
'Add Touch event to page that seted for LayoutContainer's parent eventname
'
'<code>
'Sub Panel1_Touch(Action As Int, X As Float, Y As Float)
'	BottomSheet.HandleTouchEvent(Action,X,Y)
'End Sub
'</code>
Public Sub Initialize(Parent As Panel,Callback As Object,EventName As String,LayoutContainer As Panel,BarHeight As Int)

	Me_parent	=	Parent
	Bar_Height	=	BarHeight
	
	cCallback = Callback
	cEventName = EventName

	ACTION_UP = Parent.ACTION_UP
	ACTION_DOWN = Parent.ACTION_DOWN
	ACTION_MOVE = Parent.ACTION_MOVE

	SlidingPanel = LayoutContainer
	
	Parent.AddView(LayoutContainer, 0dip, Me_parent.Height - Bar_Height, GetDeviceLayoutValues.Width, LayoutContainer.GetView(0).Height)

End Sub

'Open the CustomBottomSheet.
Public Sub OpenBottomSheet

	IsSheetOpen = True

	SlidingPanel.SetLayoutAnimated(300,1,SlidingPanel.Left,Me_parent.Height - SlidingPanel.Height + Bar_Height,SlidingPanel.Width,SlidingPanel.Height)
	
	If SubExists(cCallback, cEventName & "_AnimationComplete",1) Then

	CallSubDelayed2(cCallback, cEventName & "_AnimationComplete", IsSheetOpen)

	End If

End Sub

'Close the CustomBottomSheet.
Public Sub CloseBottomSheet

	IsSheetOpen = False

	SlidingPanel.SetLayoutAnimated(300,1,SlidingPanel.Left,Me_parent.Height - Bar_Height,SlidingPanel.Width,SlidingPanel.Height)
	
	If SubExists(cCallback, cEventName & "_AnimationComplete",1) Then

	CallSubDelayed2(cCallback, cEventName & "_AnimationComplete", IsSheetOpen)

	End If							

End Sub

'Returns the state of the CustomBottomSheet.
'True = Open, False = Closed.
Public Sub IsOpen As Boolean

	Return IsSheetOpen

End Sub

Public Sub HandleTouchEvent(Action As Int, X As Float, Y As Float) As Boolean

	'This subroutine will handle the display of the CustomBottomSheet
	'If the dragging goes beyond ~50% the height of the panel it will
	'either open or close depending on the direction you're dragging.
	If Action = ACTION_DOWN Then

	downY = Y

	End If

	If Action = ACTION_MOVE Then

	SlidingPanel.Top = SlidingPanel.Top + Y - downY

	'Here we make sure the panel doesn't "move" beyond its height
	'or dissapears completely, the CustomBottomSheet will be always
	'50dip from the bottom of the device's screen.
		If SlidingPanel.Top > Me_parent.Height - Bar_Height Then SlidingPanel.SetLayoutAnimated(1,400,SlidingPanel.Left,Me_parent.Height-Bar_Height,SlidingPanel.Width,SlidingPanel.Height) 'SlidingPanel.Top = Me_parent.Height - Bar_Height
		If SlidingPanel.Top < Me_parent.Height - SlidingPanel.Height Then SlidingPanel.SetLayoutAnimated(1,400,SlidingPanel.Left, Me_parent.Height - SlidingPanel.Height,SlidingPanel.Width,SlidingPanel.Height) 'SlidingPanel.Top = Me_parent.Height - SlidingPanel.Height

	End If

	If Action = ACTION_UP Then

		If SlidingPanel.Top + Bar_Height < Me_parent.Height - SlidingPanel.Height / 3 Then

			'SlidingPanel.Top = Me_parent.Height - SlidingPanel.Height 'Open
			SlidingPanel.SetLayoutAnimated(1,400,SlidingPanel.Left,Me_parent.Height - SlidingPanel.Height + Bar_Height,SlidingPanel.Width,SlidingPanel.Height)
			
			IsSheetOpen = True

			If SubExists(cCallback, cEventName & "_AnimationComplete",1) Then

				CallSubDelayed2(cCallback, cEventName & "_AnimationComplete", IsSheetOpen)

			End If

		End If

		If SlidingPanel.Top + SlidingPanel.Height - Bar_Height > Me_parent.Height Then

			'SlidingPanel.Top = Me_parent.Height - Bar_Height 'Close
			SlidingPanel.SetLayoutAnimated(1,400,SlidingPanel.Left, Me_parent.Height - Bar_Height,SlidingPanel.Width,SlidingPanel.Height)
			
			IsSheetOpen = False

			If SubExists(cCallback, cEventName & "_AnimationComplete",1) Then

				CallSubDelayed2(cCallback, cEventName & "_AnimationComplete", IsSheetOpen)

			End If

		End If

	End If

	Return True

End Sub