B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: MenuItemClick(ItemID As String)

Private Sub Class_Globals
	Private menu As ActionSheet
	Private lstMenu As Map
	Private lstMenu2 As List
	Private evt As String
	Private ob As Object
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Event As String,Module As Object,View1 As View)
	lstMenu2.Initialize
	evt = Event
	ob = Module
	lstMenu.Initialize
End Sub

Sub AddMenuItem(ItemID As String,Order As String,Title As String)
	lstMenu2.Add(Title)
	lstMenu.Put(Title,ItemID)
End Sub

Sub Show(Page As Page)
	menu.Initialize("items","","Cancel","",lstMenu2)
	menu.Show(Page.RootPanel)
End Sub

Private Sub items_Click (Item As String)
	If lstMenu.ContainsKey(Item) = False Then Return
	CallSubDelayed2(ob,evt & "_MenuItemClick",lstMenu.Get(Item))
End Sub