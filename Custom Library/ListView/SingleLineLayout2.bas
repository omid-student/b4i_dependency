B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
Private Sub Class_Globals
	Public Label As Label
	Private ItemHeight2 As Float
	Public Background As Int
	Private table2 As TableView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(table As TableView)
	
	Label.Initialize("")
	Label.Multiline	=	True
	Background		=	Colors.Transparent
	ItemHeight2		=	69dip
	
	table2			=	table
	
	table.RowHeight	=	ItemHeight2
	
End Sub

Public Sub setItemHeight(Height As Float)
	table2.RowHeight	=	Height
	ItemHeight2			=	Height
End Sub

Public Sub getItemHeight As Float
	Return ItemHeight2
End Sub