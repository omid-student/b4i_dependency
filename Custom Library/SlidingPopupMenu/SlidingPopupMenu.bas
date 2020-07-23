B4i=true
Group=CustomView
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: MenuItemClick(ItemID as Int)
#Event: Hide
#Event: Show

Private Sub Class_Globals
	Private actionsheet As ActionSheet
	Private ev As String
	Private ob As Object
	Private Items As List
	Private Page1 As Page
	Private ItemsMap As Map
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Page As Page,Event As String,Mobule As Object,Parent As Panel,CountItem As Int)
	
	ev	=	Event
	ob	=	Mobule
	Page1 = Page
	
	Items.Initialize
	ItemsMap.Initialize
	
End Sub

Public Sub AddMenuItem(ItemID As String,Order As Int,Title As String)
	Items.Add(Title)
	ItemsMap.Put(Title,ItemID)
End Sub

Public Sub AddMenuItem2(ItemID As String,Order As Int,Title As String,Filename As String)
	Items.Add(Title)
	ItemsMap.Put(Title,ItemID)
End Sub

Sub Show
	actionsheet.Initialize("ev","انتخاب کنید","بیخیال","",Items)
	actionsheet.Show(Page1.RootPanel)
End Sub

Sub Hide
	actionsheet.Dismiss
End Sub

Public Sub Clear
	
End Sub

Sub ev_Click (Item As String)
	
	If Item = "بیخیال" Then
		Page1.ResignFocus
		Return
	End If
	
	Dim id As Int
	id = ItemsMap.Get(Item)
	
	If SubExists(ob,ev & "_menuitemclick",1) Then CallSubDelayed2(ob,ev & "_menuitemclick",id)
	
End Sub

Public Sub getStateMenu As Boolean
	
End Sub