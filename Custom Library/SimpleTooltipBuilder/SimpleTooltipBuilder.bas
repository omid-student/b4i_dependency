B4i=true
Group=Libaries
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
Private Sub Class_Globals
	Private simple_tooltip As PopTip
	Private Def_text As String
	Private anchor_View As View
	Private direction As Int
	Private content_View As View
	Private tooltip_width As Int
	Private Page As View
	Private evt As String
	Private modu As Object
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Parent As View,Module As Object,Event As String) As SimpleTooltipBuilder
	simple_tooltip.Initialize("tooltip")
	Page			=	Parent
	evt				=	Event
	modu			=	Module
	tooltip_width	=	0.5 * Page.Width
	Return Me
End Sub

Public Sub animated(Val As Boolean) As SimpleTooltipBuilder
	
	If Val Then
		simple_tooltip.ActionAnimation	=	simple_tooltip.ActionAnimationPulse
	Else
		simple_tooltip.ActionAnimation	=	simple_tooltip.ActionAnimationNone
	End If
	
	Return Me
	
End Sub

Public Sub width(val As Int) As SimpleTooltipBuilder
	tooltip_width	=	val
	Return Me
End Sub

'set view's width and height
Public Sub contentView(View As View) As SimpleTooltipBuilder
	content_View	=	View
	Return Me
End Sub

Public Sub animationDuration(Val As Float) As SimpleTooltipBuilder
	simple_tooltip.AnimationIn	=	Val/1000
	simple_tooltip.AnimationOut	=	Val/1000
	Return Me
End Sub

Public Sub fontFamily(font2 As Font) As SimpleTooltipBuilder
	simple_tooltip.Font = font2
	Return Me
End Sub

Public Sub arrowHeight(Val As Float) As SimpleTooltipBuilder
	simple_tooltip.ArrowHeight	=	Val
	Return Me
End Sub

Public Sub backgroundColor(Val As Int) As SimpleTooltipBuilder
	simple_tooltip.PopoverColor	=	Val
	Return Me
End Sub

Public Sub transparentOverlay(Val As Boolean) As SimpleTooltipBuilder
	Return Me
End Sub

Public Sub dismissOnInsideTouch(Val As Boolean) As SimpleTooltipBuilder
	simple_tooltip.ShouldDismissOnTap	=	Val
	Return Me
End Sub

Public Sub dismissOnOutsideTouch(Val As Boolean) As SimpleTooltipBuilder
	simple_tooltip.ShouldDismissOnTapOutside	=	Val
	Return Me
End Sub

Public Sub modal(Val As Boolean) As SimpleTooltipBuilder
	Return Me
End Sub

Public Sub text(Val As String) As SimpleTooltipBuilder
	Def_text	=	Val
	Return Me
End Sub

Public Sub textColor(Color As Int) As SimpleTooltipBuilder
	simple_tooltip.TextColor	=	Color
	Return Me
End Sub

Public Sub anchorView(View As View) As SimpleTooltipBuilder
	anchor_View	=	View
	Return Me
End Sub

Public Sub gravityBottom As SimpleTooltipBuilder
	direction	=	simple_tooltip.DirectionDown
	Return Me
End Sub

Public Sub gravityTop As SimpleTooltipBuilder
	direction	=	simple_tooltip.DirectionUp
	Return Me
End Sub

Public Sub gravityEnd As SimpleTooltipBuilder
	direction	=	simple_tooltip.DirectionRight
	Return Me
End Sub

Public Sub gravityStart As SimpleTooltipBuilder
	direction	=	simple_tooltip.DirectionLeft
	Return Me
End Sub

Public Sub rounded As SimpleTooltipBuilder
	simple_tooltip.Rounded	= True
	Return Me
End Sub

Public Sub padding(Val As Float) As SimpleTooltipBuilder
	simple_tooltip.Padding	=	Val
	Return Me
End Sub

Public Sub build As SimpleTooltipBuilder
	Return Me
End Sub

Public Sub show

	Dim PopTipFrame As Rect
	PopTipFrame.Initialize(anchor_View.Left,anchor_View.Top,anchor_View.Width + anchor_View.left ,anchor_View.Height + anchor_View.Top)
	
	If content_View.IsInitialized = False Then
		simple_tooltip.ShowText(Def_text,direction,tooltip_width,Page,PopTipFrame)
	Else

		If content_View Is Label Then
			
			Dim lb As Label
			lb				=	content_View
			
			If Def_text.Length > 0 Then
				lb.Text			=	Def_text
				lb.Multiline	=	True
				lb.SizeToFit
				content_View	=	lb
			Else if lb.Text.Length > 0 Then
				lb.Multiline	=	True
				lb.SizeToFit
				content_View	=	lb
			End If
			
			If lb.Width > Page.Width Then
				lb.Width	=	Page.Width / 1.5
				lb.Height	=	lb.Text.MeasureHeight(lb.Font) + 20dip
			End If
			
		End If
		
		simple_tooltip.ShowCustomView(content_View,direction,Page,PopTipFrame)
		
	End If
	
End Sub

Public Sub dismiss As SimpleTooltipBuilder
	simple_tooltip.Hide
	Return Me
End Sub

Public Sub getisShowing As Boolean
	Return simple_tooltip.IsVisible
End Sub

Private Sub tooltip_Appear
	
	If SubExists(modu,evt & "_appear",0) Then
		CallSub(modu,evt & "_appear")	
	End If
	
End Sub

Private Sub tooltip_Click
	
	If SubExists(modu,evt & "_click",0) Then
		CallSub(modu,evt & "_click")
	End If
	
End Sub

Private Sub tooltip_Dismiss
	
	If SubExists(modu,evt & "_dismiss",0) Then
		CallSub(modu,evt & "_dismiss")
	End If
	
End Sub

Private Sub tooltip_LongClick
	
	If SubExists(modu,evt & "_longclick",0) Then
		CallSub(modu,evt & "_longclick")
	End If
	
End Sub

Private Sub tooltip_Tap
	
	If SubExists(modu,evt & "_appear",0) Then
		CallSub(modu,evt & "_appear")
	End If
	
End Sub