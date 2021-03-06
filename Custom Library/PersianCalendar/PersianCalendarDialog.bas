﻿B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
Private Sub Class_Globals
	Private dialog As CustomLayoutDialog
	Private base As Panel
	Private pr As PersianCalendar
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Page1 As Page,Fontname As String)

	base.Initialize("")
	base.SetLayoutAnimated(1,1,0,0,GetDeviceLayoutValues.Width - 100dip,GetDeviceLayoutValues.Width)
	
	Dim lbl As Label
	lbl.Initialize("")
	
	Dim properties As Map
	properties.Initialize
	properties.Put("fontname",Fontname)
	properties.Put("headerfontcolor",Colors.Black)
	properties.Put("headerbgcolor",Colors.White)
	properties.Put("headerfontsize",14)
	properties.Put("itemfontcolor",0xFF000000)
	properties.Put("itembgcolor",Colors.ARGB(20,20,20,20))
	properties.Put("itemgridcolor",Colors.White)
	properties.Put("itemgridcorner",1)
	properties.Put("itemfontsize",14)
	properties.Put("selectedday",0xFFB7B7B7)
	properties.Put("selecteddaytextcolor",0xFF2C2C2C)
	properties.Put("selecteddayisbold",True)
	properties.Put("fridaycolor",0xFFB71A1A)
	properties.Put("short_days",True)
	properties.Put("fontname",Font.DEFAULT.Name)
	
	pr.Initialize(Me,"calendar")
	pr.DesignerCreateView(base,lbl,properties)
	
End Sub

#IgnoreWarnings: 12
Sub GetPersianCalendar As PersianCalendar
	Return pr
End Sub

Sub Show As ResumableSub
	
	dialog.Initialize(base)
	dialog.Style	=	dialog.STYLE_CUSTOM
	
	Dim ob As Object
	ob	=	dialog.ShowAsync("","تایید","انصراف","",True)
	
	Wait For (ob) Dialog_Result(Result As Int)
		If Result = dialog.RESULT_POSITIVE Then
			Return	pr.getDate
		Else
			Return	Null
		End If
	
End Sub