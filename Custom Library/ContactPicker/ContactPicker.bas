B4i=true
Group=Main Library
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: ContactChooser(ContactDetails As cuContact)

Private Sub Class_Globals
	Private cutils As ContactsUtils
	Private TableView1 As TableView
	Private fetchedContacts As List
	Private Page1 As Page
	Private modu As Object
	Private evt As String
	Private Nav2 As NavigationController
End Sub

Sub Initialize(Nav As NavigationController,Module As Object,Event As String)
	
	evt		=	Event & "_contactchooser"
	modu	=	Module
	Nav2	=	Nav
	
	Page1.Initialize("Page1")
	TableView1.Initialize("TableView1",False)
	
	Page1.HideBackButton = False
	Page1.TopRightButtons	=	Array(CreateFABarButton("exit"))
	Page1.Title = "Contact Picker"
	Page1.RootPanel.Color = Colors.White
	
	cutils.Initialize(Me, "cutils")
	
	If cutils.AuthorizationDenied Then
		Msgbox("Please accept contact's permission for load it", "")
		Return
	End If
	
	TableView1.RowHeight = 60dip
	fetchedContacts.Initialize
	
End Sub

Sub Show
	Nav2.ShowPage(Page1)
End Sub

Private Sub CreateFABarButton(tag As Object) As BarButton
	Dim bb As BarButton
	Dim b As Button
	b.InitializeCustom("BarButton", 0xFF007AFF, 0xFFE3EBF4)
	b.CustomLabel.Font = Font.CreateFontAwesome(24)
	b.Text = Chr(0xF00D)
	b.Tag = tag
	b.SetLayoutAnimated(0, 1, 0, 0, 30, 40)
	bb.InitializeCustom(b)
	Return bb
End Sub

Private Sub BarButton_Click
	Nav2.RemoveCurrentPage
End Sub

Private Sub Page1_Resize(Width As Int,Height As Int)
	Page1.RootPanel.AddView(TableView1,0,50dip,Page1.RootPanel.Width,Page1.RootPanel.Height)
	Dim lb As Label
	lb.Initialize("lblback")
	lb.Text	=	"  " & Chr(0xF104)
	lb.Color = Colors.Gray
	lb.TextAlignment = lb.ALIGNMENT_LEFT
	lb.Font = Font.CreateFontAwesome(30)
	lb.TextColor	=	Colors.White
	Page1.RootPanel.AddView(lb,0,0,40dip,50dip)
	
	Dim lb2 As Label
	lb2.Initialize("lblback")
	lb2.Text	=	" Back"
	lb2.Color = Colors.Gray
	lb2.TextAlignment = lb2.ALIGNMENT_LEFT
	lb2.TextColor	=	Colors.White
	Page1.RootPanel.AddView(lb2,lb.Left+lb.Width,0,Page1.RootPanel.Width,50dip)
	GetAllContacts
End Sub

Private Sub GetAllContacts
	'get all contacts. Prefetch the phone numbers and thumbnial
	cutils.GetContacts(Array(cutils.contacts.ContactThumbnailImageDataKey, cutils.contacts.ContactPhoneNumbersKey))
End Sub

Private Sub cutils_Available (Success As Boolean, Contacts As List)
	If Success = False Then
		Msgbox("Error getting contacts", "")
		Log(LastException)
		Return
	End If
	fetchedContacts = Contacts
	TableView1.Clear
	Contacts.SortType("DisplayName", True)
	For Each cu As cuContact In Contacts
		Dim phones As List = cutils.GetPhones(cu)
		Dim phone As String
		If phones.Size > 0 Then
			Dim cp As cuPhone = phones.Get(0)
			phone = cp.Number
		Else
			phone = "N/A"
		End If
		Dim t As TableCell = TableView1.AddTwoLines(cu.DisplayName, phone)
		t.Tag = cu
	Next
	TableView1.ReloadAll
End Sub

Private Sub TableView1_SelectedChanged (SectionIndex As Int, Cell As TableCell)
	
	Dim cu As cuContact = Cell.Tag
	
	Dim co As ContactsUtils
	co.Initialize(Me,"")
	
	cu.Phones = co.GetPhones(cu)
	
	BarButton_Click
	
	CallSubDelayed2(modu,evt,cu)
	
End Sub

Private Sub RoundBitmap(Bitmap As Bitmap) As Bitmap
	
	If Bitmap.IsInitialized =	False Then Return Null
	
	Dim img As ImageView
	img.Initialize("")
	Page1.RootPanel.AddView(img,0,0,Bitmap.Width,Bitmap.Height)
	img.Bitmap = Bitmap
	img.SetBorder(0,Colors.Transparent,Bitmap.Width/2)
	
	Dim img2 As ImageView
	img2.Initialize("")
	Page1.RootPanel.AddView(img2,-Bitmap.Width,-Bitmap.Height,Bitmap.Width,Bitmap.Height)
	
	Dim cvs As Canvas
	cvs.Initialize(img)
	Dim dest As Rect
	dest.Initialize(0, 0, img.Width, img.Height)
	cvs.DrawView(img2, dest)
	cvs.Refresh
	
	Dim output As Bitmap
	output = cvs.CreateBitmap
	
	img.RemoveViewFromParent
	img2.RemoveViewFromParent
	
	Return output
	
End Sub

Public Sub GetPhones(cuContact As cuContact) As List
	Return cutils.GetPhones(cuContact)
End Sub

Sub lblback_Click
	Main.NavControl.RemoveCurrentPage
End Sub