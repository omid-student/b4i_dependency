B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
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

'use values from your data
Sub Apply(View1 As View)
	
	Dim b1 As Button
	Dim lb As Label
	
	If View1 Is Button Then
		b1	=	View1
		b1.Color = sColor
		b1.SetBorder(sBorderWidth,sBorderColor,sRadius)
		
	Else if View1 Is Panel Then
		Dim p As Panel
		p = View1
		p.Color = sColor
		p.SetBorder(sBorderWidth,sBorderColor,sRadius)
		
	Else if View1 Is Label Then
		lb  = View1
		lb.Color = sColor
		lb.SetBorder(sBorderWidth,sBorderColor,sRadius)
	
	Else if View1 Is TextField Then
		Dim p23 As TextField
		p23 = View1
		p23.Color = sColor
		p23.SetBorder(sBorderWidth,sBorderColor,sRadius)
		
	Else
		View1.Color	=	sColor
		View1.SetBorder(sBorderWidth,sBorderColor,sRadius)
	End If
	
End Sub

'Border width is 0 and color is transparent
Sub Apply2(View1 As View)
	
	Dim b1 As Button
	Dim lb As Label
	
	If View1 Is Button Then
		b1	=	View1
		b1.Color = sColor
		b1.SetBorder(0,0,sRadius)
		
	Else if View1 Is Panel Then
		Dim p As Panel
		p = View1
		p.Color = sColor
		p.SetBorder(sBorderWidth,sBorderColor,sRadius)
	
	Else if View1 Is TextField Then
		Dim p23 As TextField
		p23 = View1
		p23.Color = sColor
		p23.SetBorder(sBorderWidth,sBorderColor,sRadius)
		
	Else
		lb  = View1
		lb.Color = sColor
		lb.SetBorder(sBorderWidth,sBorderColor,sRadius)
		
	End If
	
End Sub