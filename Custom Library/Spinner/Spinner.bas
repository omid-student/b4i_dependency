B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
'Custom View class 
#Event: ItemClick (Position As Int, Value As Object)
#DesignerProperty: Key: cancel_title, DisplayName: Cancel Title, FieldType: String, DefaultValue: Cancel
#DesignerProperty: Key: title, DisplayName: List Title, FieldType: String, DefaultValue: Choose
#DesignerProperty: Key: default, DisplayName: Default Value, FieldType: String, DefaultValue: Select an Option
#IgnoreWarnings:9
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As WeakRef
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Private sheet As ActionSheet
	Private Items As List
	Private prop As Map
	Private bt As Button
	Private selected As Int : selected = -1
	Private lblDown As Label
	Private hint_index As Int = -1
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	
	mBase.Value = 	Base
	prop		=	Props
	
	lblDown.Initialize("")
	lblDown.Font				=	Font.CreateMaterialIcons(20)
	lblDown.Text				=	Chr(0xE5CF)
	lblDown.SetBorder(0,0,0)
	lblDown.TextAlignment		=	lblDown.ALIGNMENT_LEFT
	lblDown.TextColor			=	Lbl.TextColor
	Base.AddView(lblDown,0,0,30dip,Base.Height)
	lblDown.Top = Base.Height / 2 - lblDown.Height / 2
	
	bt.InitializeCustom("btnlist",Colors.Black,Colors.Gray)
	bt.CustomLabel.Font				=	Lbl.Font
	bt.Text							=	"Select"
	bt.CustomLabel.SetBorder(0,0,0)
	
	If Lbl.TextAlignment = Lbl.ALIGNMENT_CENTER Then
		SetButtonAlignment(bt,0)
	Else If Lbl.TextAlignment = Lbl.ALIGNMENT_LEFT Then
		SetButtonAlignment(bt,1)
	Else If Lbl.TextAlignment = Lbl.ALIGNMENT_RIGHT Then
		SetButtonAlignment(bt,2)
	End If
	
	SetButtonTextColor(bt,Lbl.TextColor,Lbl.TextColor - 10,Colors.Gray)
	bt.CustomLabel.TextColor		=	Lbl.TextColor
	Base.AddView(bt,lblDown.Width+lblDown.Left-5dip,0,Base.Width-lblDown.Width-lblDown.Left-12dip,Base.Height)
	
	Items.Initialize
	
	bt.Text	=	Props.Get("default")
	
End Sub

Sub Add(Item As Object)
	
	Items.Add(Item)
	
	If selected <> -1 Then
		If selected = Items.Size - 1 Then
			bt.Text	=	Item	
		End If
	End If
	
End Sub

'0 - center, 1 - left, 2 - right
Private Sub SetButtonAlignment(btn As Button, alignment As Int)
	Dim No As NativeObject = btn
	No.SetField("contentHorizontalAlignment", alignment)
End Sub

Private Sub SetButtonTextColor(Button1 As Button, NormalColor As Int,PressColor As Int,DisableColor As Int)
	Dim No As NativeObject = Button1
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(NormalColor), 0))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(PressColor), 1))
	No.RunMethod("setTitleColor:forState:", Array(No.ColorToUIColor(DisableColor), 2))
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
End Sub

Private Sub GetBase As Panel
	Return mBase.Value
End Sub

Public Sub NoIcon
	lblDown.Visible	=	False
	bt.Left			=	lblDown.Left + 10dip
	bt.Width		=	bt.Width + lblDown.Width - 10dip
End Sub

Public Sub setHintIndex(Index As Int)
	hint_index	=	Index
End Sub

Public Sub Get(Index As Int) As Object
	Return Items.Get(Index)
End Sub

Public Sub GetItem(Index As Int) As String
	Return Items.Get(Index)	
End Sub

Public Sub getSelectedItem As String
	Return bt.Text
End Sub

Public Sub Size As Int
	Return Items.Size
End Sub

Private Sub btnlist_Click
	
	Dim default As String
	
	If selected <> -1 Then
		default	=	Items.Get(selected)
	End If
	
	sheet.Initialize("sheet",prop.Get("title"),prop.Get("cancel_title"),default,Items)
	sheet.Show(GetBase)
	
End Sub

Public Sub setSelectedIndex(Value As Int)
	
	Dim data As String
	data		=	Items.Get(Value)
	selected	=	Value
	bt.Text		=	data
	
End Sub

Public Sub setSelectItem(Value As Object)
	bt.Text		=	Value
End Sub

Private Sub sheet_Click (Item As String)
	
	If Item = prop.Get("cancel_title") Then Return
	
	bt.Text	=	Item
	
	If SubExists(mCallBack,mEventName & "_itemclick",2) Then
		CallSub3(mCallBack,mEventName & "_itemclick",0,Item)
	End If
	
End Sub