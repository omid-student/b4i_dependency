Type=Class
Version=4.01
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
Private Sub Class_Globals
	Private sRadius			As Int
	Private sColor			As Int
	Private sBorderWidth		As Int
	Private sBorderColor		As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Color As Int,CornerRadius As Int)

	sRadius 		= CornerRadius
	sColor			= Color
	
End Sub

Public Sub Initialize2(Color As Int,CornerRadius As Int,BorderWidth As Int,BorderColor As Int)

	sRadius 		= CornerRadius
	sColor			= Color
	sBorderWidth	= BorderWidth
	sBorderColor	= BorderColor
	
End Sub

Sub Apply(View1 As View)
	
	Dim b1 As Button
	Dim lb As Label
	
	If View1 Is Button Then
		b1	=	View1
		b1.Color = sColor
		b1.SetBorder(sBorderWidth,sBorderColor,sRadius)
	Else
		lb  = View1
		lb.Color = sColor
		lb.SetBorder(sBorderWidth,sBorderColor,sRadius)
	End If
	
End Sub

Sub Apply2(View1 As View)
	
	Dim b1 As Button
	Dim lb As Label
	
	If View1 Is Button Then
		b1	=	View1
		b1.Color = sColor
		b1.SetBorder(0,0,sRadius)
	Else
		lb  = View1
		lb.Color = sColor
		lb.SetBorder(0,0,sRadius)
	End If
	
End Sub