Type=Class
Version=1.21
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Class module
'
'BarDropDown
'Written by Stevel05
'25/11/2014
'provides CallBack: EventName_Click(Tag As Object)
'
'

Sub Class_Globals
	Private mModule As Object
	Private mEventName As String
	Private ViewMap As Map
	Private Pnl As Panel
	Private ItemHeight As Int = 30
	Private mRootPnl As Panel
	Private BFont As Font
	Private BTint As Int
	Private CurrentButton As BarButton
	Private Padding As Int = 4
	Private LeftMargin As Int = 2
	Private BSelectedTintColor As Int = Colors.ARGB(100,0,0,0)

End Sub

'Initializes the object. You can add parameters to this method if needed.
' The module is the calling module, the EventName is used as a prefix with "_Click(Tag as Object)" to 
'call a sub In the calling module when a menu item Is clicked
Public Sub Initialize(Module As Object,EventName As String)
	mModule = Module
	mEventName = EventName
	
	ViewMap.Initialize
	
	'Set up the panel
	Pnl.Initialize("")
	'Approximation of the color of the toolbar
	Pnl.Color = Colors.RGB(239,239,239)
	Pnl.SetBorder(1,Colors.LightGray,0)
	Pnl.Visible = False
	
	'Font for our Labels
	BFont = Font.CreateNew2(Font.DEFAULT.Name,17.00)
	
End Sub
Sub AddToParent(RootPnl As Panel)
	mRootPnl = RootPnl
	'Add the panel at an arbitray location
	RootPnl.AddView(Pnl,0,0,50,30)
End Sub
'Gets the left position of the bar button
Private Sub Left(BBtn As NativeObject) As Int
	Dim VNO As NativeObject = BBtn.RunMethod("valueForKey:",Array("view"))
	Dim Frame As NativeObject = VNO.GetField("frame")
	Dim RectStr As String = Frame.AsString
	'Cannot use an NSRect object, so convert it to a Rect we can use
	Dim R As Rect = Utils.NSRectToRect(RectStr)
	Return R.Left
End Sub
'Add the menus for the drop downs 
'NOTE: the menus on the TopRightButtons are in the reverse display order, this is how Page1.TopRightButtons is returned
'Menu should contain a List of Arrays which hold the text and tag for each menu item
'Add 'Null' for positions where no menus are required
Sub AddDropDowns(BtnList As List,Menu As List)
	
	'Check we have the right number of entries
	If BtnList.Size <> Menu.Size Then
		LogColor("BarDropDown - AddDropDowns: List Sizes do not match",Colors.Red)
		Return
	End If
	
	'Set the tint color
	BTint = Colors.rgb(0,122,255)
	
	
	For i = 0 To BtnList.Size - 1
	
		'Get the next bar button
		Dim B As BarButton = BtnList.Get(i)

		'And it's corresponding menu entry
		Dim M() As String = Menu.Get(i)
		
		'Check we can capture a click on the specified button, and it's menu entry is not Null
		If B.Tag <> "" AND M <> Null Then
		
			'Find the longest text for the menu
			Dim MenuWidth As Int
			For Each Item As String In Menu.Get(i)
				MenuWidth = Max(MenuWidth,Item.MeasureWidth(BFont) + Padding)
			Next
			
			'Store the data in our map
			ViewMap.Put(B.Tag,B)
			ViewMap.Put(B.Tag & "Menu",Menu.Get(i))
			ViewMap.Put(B.Tag & "MenuWidth",MenuWidth)
		End If
	Next
	
End Sub
Private Sub Show(Tag As String)
	
	'Clear the panel
	Pnl.RemoveAllViews
	
	'Get the data from the Map
	Dim Menus() As String = ViewMap.Get(Tag & "Menu")
	Dim MenuWidth As Int = ViewMap.Get(Tag & "MenuWidth")
	
	'Build the new panel content
	For i = 0 To Menus.Length - 1
		Dim Lbl As Label
		Lbl.Initialize("Lbl")
		Lbl.Text = Menus(i)
		Lbl.Tag = Menus(i)
		Lbl.Font = BFont
		Lbl.TextColor = BTint
		Pnl.AddView(Lbl,LeftMargin,i * ItemHeight,MenuWidth,ItemHeight)
	Next
	
	'Size the panel
	Pnl.Left = Min(mRootPnl.Width - MenuWidth,Left(ViewMap.Get(Tag)) - LeftMargin)
	Pnl.Height = Menus.Length * ItemHeight
	Pnl.Width = MenuWidth
	
	'Record the current button by it's tag
	Pnl.Tag = Tag
	
	'Show it
	Pnl.Visible = True
	Pnl.BringToFront
	
End Sub
'Call this sub to the calling module's BarButtonClick Event.  
'Will Return True If there Is a dropdown For the tag, or False if not
'
'<code>Sub Page1_BarButtonClick (Tag As String)
'	If BDD.ManageBarClick(Tag) Then Return
'	'Process anything else
'End Sub</code>
Sub ManageBarClick(Tag As String) As Boolean
	
	'Get the button selected from out Map
	Dim B As BarButton =  ViewMap.Get(Tag)

	'There is no menu for this button
	If Not(B.IsInitialized) Then 
		'Hide the current panel anyway
		HidePanel
		'Tell the calling module we haven't dealt with the click
		Return False
	End If

	'Set the selected color
	B.TintColor = BSelectedTintColor
	
	'Just hide the panel if the same button is touched
	If B = CurrentButton Then
		HidePanel
		Return True
	End If
	
	'Hide the current panel
	HidePanel
	
	'Set the current button
	CurrentButton = B
	
	'Show the new panel
	Show(Tag)
	
	'Tell the calling module we have dealt with the click
	Return True
End Sub
Private Sub Lbl_Click
	HidePanel
	'initialte our callback
	Dim L As Label = Sender
	If SubExists(mModule,mEventName & "_click",1) Then
		CallSub2(mModule,mEventName & "_click",L.Tag)
	End If
End Sub
'Hides the current panel
Sub HidePanel
	Pnl.Visible = False
	Dim B As BarButton =  ViewMap.Get(Pnl.Tag)
	'Reset the color
	If B.IsInitialized Then B.TintColor = BTint
	'Reset variables
	Pnl.Tag = ""
	CurrentButton = Null
End Sub