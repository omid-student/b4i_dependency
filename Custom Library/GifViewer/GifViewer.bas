B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.01
@EndOfDesignText@
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As WeakRef
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Private iv As WebView
	Private bs As Panel
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	
	mBase.Value = Base
	Base.Color	=	Colors.Transparent
	iv.Initialize("")
	Base.AddView(iv,0,0,Base.Width,Base.Height)
	iv.UserInteractionEnabled =	False
	iv.Color	=	Colors.Transparent
	
	bs	=	Base
 
End Sub

Public Sub Load(Dir As String,Filename As String,BackgroundColor As String)

	If bs.IsInitialized = False Then Return
	
	iv.SetBorder(14dip,Hex2RGB(BackgroundColor),0)
	bs.SetBorder(14dip,Hex2RGB(BackgroundColor),0)
	
	Dim html As String
	html	=	$"<p style="border:0;text-align:center;background-color:${BackgroundColor}">"$
	html	=	html & $"<img width=100% style="border:0;background-color:${BackgroundColor}" src="${File.Combine(Dir,Filename)}">"$
	html	=	html & "</p>"

	iv.LoadHtml(html)
	
End Sub

Public Sub setFitMode(Value As Boolean)
	iv.ScaleToFit	=	Value	
End Sub

Public Sub Clear
	iv.LoadHtml("")
End Sub

Private Sub Hex2RGB(Hex As String) As Int
	Hex = Hex.Replace("###","#").Replace("##","#")
	If Hex.SubString2(0,1) <> "#" Then Hex = "#" & Hex
	Dim m As Map
	m.Initialize
	Dim r,g,b As Int
	r = Bit.ParseInt(Hex.SubString2(1,3), 16)
	g = Bit.ParseInt(Hex.SubString2(3,5), 16)
	b = Bit.ParseInt(Hex.SubString2(5,7), 16)
	m.Put("r",r)
	m.put("g",g)
	m.Put("b", b)
	Return Colors.RGB(r,g,b)
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
End Sub

Public Sub GetBase As Panel
	Return bs
End Sub