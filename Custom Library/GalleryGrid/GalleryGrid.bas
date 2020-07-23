B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: OnDownloadBitmap(Bitmap As Bitmap)
#Event: OnDownloadBitmap(Index As int,Bitmap As Bitmap)
#Event: ItemClick(Index As Int)
#Event: ItemClick(Index As Int,ImageView2 As ImageView)
#Event: ItemLongClick(Index As Int)
#Event: GetImageView(ImageView1 As ImageView,Index As Int)
#Event: OverScrolled
#Event: BottomScroll

Private Sub Class_Globals
	Private table As TableView
	Private parent_panel As Panel
	Private Imageviews As List
	Private caches2 As Map
	Private place_holder As Bitmap
	Private modu As Object
	Private ev As String
	Private UnUseImageviews As List
	Private refresh_control As Object
	Private PullState As Boolean
	Private BorderWidth As Int	:	BorderWidth	=	1
	Private CurrentPositionScroll As Int
	Private iCache As Boolean
	Private su As StringUtils
	Private Count As Int
	Private Lock As Boolean
End Sub

'Parent is panel that grid add into it
Public Sub Initialize(Module As Object,Event As String,Parent As Panel)
	
	parent_panel	=	Parent
	modu			=	Module
	ev				=	Event
	
	table.Initialize("table",False)
	Imageviews.Initialize
	caches2.Initialize
	
	Parent.AddView(table,0,0,Parent.Width,Parent.Height)
	table.RowHeight			= 	Parent.Width / 3
	table.Color				=	Colors.Transparent
	table.SeparatorColor	=	Colors.Transparent
 	
	UnUseImageviews.Initialize

	AddEventsToTable

End Sub

Sub setVisible(State As Boolean)
	table.Visible = State
End Sub

'change state of gallery grid
Sub setEnabled(Value As Boolean)
	table.UserInteractionEnabled	=	Value
End Sub

'set border with of item(image)
Sub setBorderWidth(Value As Int)
	BorderWidth	=	Value
End Sub

'save all images that downloaded
Sub setCache(Value As Boolean)
	iCache	=	Value	
End Sub

'get pictures count in grid
Sub getCountItem As Int
	Return Count
End Sub

'scroll grid to bottom
Sub ScrollToBottom
	table.ScrollTo(0,table.GetItems(0).Size-1,table.SCROLL_BOTTOM)	
End Sub

'scroll grid to top
Sub ScrollToTop
	table.ScrollTo(0,0,table.SCROLL_TOP)	
End Sub

'hide scrollbar in grid
Sub RemoveScrollbar
	Dim no As NativeObject = table
	no.SetField("showsHorizontalScrollIndicator", False)
End Sub

'Hide refresh view fron top
Public Sub HideRefreshView
	If PullState Then
		Dim no As NativeObject=refresh_control
		no.RunMethod("endRefreshing",Null) ' END REFRESHING
		PullState	=	False
	End If
End Sub

'if set True,When user pull scroll to down,event OverScrolled raised
Public Sub setPullDownRefresh(State As Boolean)
	If State Then 	AddRefresh
End Sub

'if picture cannot download,so show this bitmap instead of it
Public Sub setPlaceHolder(Bitmap As Bitmap)
	place_holder = Bitmap
End Sub

'List can be contain urls or bitmaps
Sub Add(Images As List)
	
	Imageviews.Clear
	
	If UnUseImageviews.Size > 0 Then
		For j = 0 To UnUseImageviews.Size - 1
			If j > Images.Size - 1 Then Exit
			Dim img As ImageView
			img = UnUseImageviews.Get(0)
			img.Visible	=	True
			img.Tag 	= 	Count
			img.Color	=	Colors.Transparent
			Count = Count + 1
			ShowBitmap(img,Images.Get(0))
			UnUseImageviews.RemoveAt(0)
			Images.RemoveAt(0)
			If SubExists(modu,ev & "_gettmageview",2) Then
				CallSubDelayed3(modu,ev & "_getimageview",img,img.Tag)
			End If
		Next
	End If
	
	For i = 0 To Images.Size - 1 Step 3
		AddCellItem(Images.Get(i),i)
	Next
	
	For i = 0 To Imageviews.Size - 1
		
		Dim img As ImageView
		img = Imageviews.Get(i)
		
		If i > Images.Size-1 Then
			UnUseImageviews.Add(img)
			img.Visible	=	False
		Else
			img.Tag = Count
			Count = Count + 1
			ShowBitmap(img,Images.Get(i))
			If SubExists(modu,ev & "_gettmageview",2) Then
				CallSubDelayed3(modu,ev & "_getimageview",img,img.Tag)
			End If
		End If
		
	Next
	
	table.ReloadAll
	
	Lock = False
	
End Sub

Private Sub AddCellItem(Data As Object,Position As Int)
	
	Dim tc As TableCell = table.AddSingleLine("")
	tc.ShowSelection = False
	tc.CustomView = CreateItem(Data,Position)
	
End Sub

Private Sub ShowBitmap(ImageView1 As ImageView,Data As Object)
	
	Dim Glide As Amir_Glide
	Glide.Initialize
	
	If Data Is Bitmap Then
		ImageView1.Bitmap	=	Data
		Return
	End If
	
	Dim str As String
	str = Data
	If str.StartsWith("http") = False And str.StartsWith("www.") = False Then
		Glide.LoadFile(str,"").WithFade(0.5).Apply(Glide.RO.CenterCrop).Into(ImageView1)
	Else
		Glide.Load(Data).WithFade(0.5).Listener("listen",Me,ImageView1).Submit
	End If
	
End Sub

Sub Clear
	Count					=	0
	CurrentPositionScroll	=	0
	UnUseImageviews.Clear
	caches2.Clear
	Imageviews.Clear
	table.Clear
End Sub

Public Sub AsView As TableView
	Return table
End Sub

Private Sub CreateItem(Item As Object,Index As Int) As Panel
	
	Dim p As Panel
	p.Initialize("")
	p.Width		=  parent_panel.Width
	p.Height	= table.RowHeight
	
	Dim img As ImageView
	img.Initialize("img")
	p.AddView(img,0,0,p.Width/3,p.Height)
	img.ContentMode	=	img.MODE_FILL
	img.Color = Colors.RGB(221, 221, 221)
	img.Tag	=	Index
	img.SetBorder(BorderWidth,Colors.White,0)
	Imageviews.Add(img)
	
	Dim img2 As ImageView
	img2.Initialize("img")
	p.AddView(img2,img.Width,0,p.Width/3,p.Height)
	img2.ContentMode	=	img.MODE_FILL
	img2.Tag	=	Index + 1
	img2.Color = Colors.RGB(221, 221, 221)
	img2.SetBorder(BorderWidth,Colors.White,0)
	Imageviews.Add(img2)
	
	Dim img3 As ImageView
	img3.Initialize("img")
	p.AddView(img3,img.Width+img.Width,0,p.Width/3,p.Height)
	img3.ContentMode	=	img.MODE_FILL
	img3.Tag	=	Index + 2
	img3.Color = Colors.RGB(221, 221, 221)
	img3.SetBorder(BorderWidth,Colors.White,0)
	Imageviews.Add(img3)
	
	Return p
	
End Sub

Private Sub img_Click
	
	Dim img As ImageView
	img	=	Sender
	
	If img.Tag <> Null Then
		If SubExists(modu,ev.ToLowerCase & "_itemclick",1) Then
			CallSubDelayed2(modu,ev.ToLowerCase & "_itemclick",img.Tag)
		Else if SubExists(modu,ev.ToLowerCase & "_itemclick",2) Then
			CallSubDelayed3(modu,ev.ToLowerCase & "_itemclick",img.Tag,img)
		End If
	End If
		
End Sub

Private Sub img_LongClick
	
	Dim img As ImageView
	img	=	Sender
	
	If img.Tag <> Null Then
		CallSubDelayed2(modu,ev.ToLowerCase & "_itemlongclick",img.Tag)
	End If
		
End Sub

Private Sub listen_onResourceReady (Bitmap As Object,IsFirstResource As Boolean,Tag As Object)
	
	Dim img As ImageView
	img			=	Tag
	img.Bitmap	=	Bitmap
	
	If SubExists(modu,ev & "_ondownloadbitmap",1) Then
		CallSub2(modu,ev & "_ondownloadbitmap",Bitmap)
	End If
	
	If SubExists(modu,ev & "_ondownloadbitmap",2) Then
		Dim b As Bitmap
		b = Bitmap
		CallSub3(modu,ev & "_ondownloadbitmap",img.Tag,b)
	End If
	
End Sub

#region event table
Private Sub AddEventsToTable
	
	Dim no As NativeObject = table 'scrollview or tableview
	
	no.SetField("showsVerticalScrollIndicator", False)
	
	Dim no As NativeObject	= table
	no.setField("delegate",Me)
	
End Sub

Private Sub AddRefresh
	Dim nome As NativeObject=Me
	nome.RunMethod("AddRefresh:",Array(table))
End Sub

Private Sub refreshing(RefreshControl As Object)
	refresh_control	=	RefreshControl
	PullState		=	True
	CallSubDelayed(modu,ev & "_overscrolled")
End Sub

Private Sub GetTopItem As Int()
	Try
		Dim no As NativeObject = table
		no = no.RunMethod("indexPathsForVisibleRows", Null).RunMethod("objectAtIndex:", Array(0))
		Return Array As Int(no.GetField("section").AsNumber, no.GetField("row").AsNumber)
	Catch
		Return Array As Int(0,0)
	End Try
End Sub

#IF OBJC

-(void)AddRefresh: (UIScrollView*)scrollView {
UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
[scrollView addSubview:refreshControl];
[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

}

- (void)refresh:(id)sender {
UIRefreshControl *refreshControl=sender;
[self.bi raiseEvent:nil event:@"refreshing:" params:@[(refreshControl)]];

}

#END IF

Private Sub sc_begin(OffsetX As Int, OffsetY As Int)

End Sub

Private Sub sc_ScrollChanged (OffsetX As Int, OffsetY As Int)

End Sub

Private Sub sc_bottom
	
	If Lock Then Return
	Lock = True
	
	CallSubDelayed(modu,ev.ToLowerCase & "_BottomScroll")
	
End Sub

#if OBJC

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

 
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height-150;

    float reload_distance = 10;
    if(y > h + reload_distance) {
        [self.bi raiseUIEvent:nil event:@"sc_bottom" params:@[]];
    }
 
    [self.bi raiseUIEvent:nil event:@"sc_scrollchanged::" params:@[@((float)scrollView.contentOffset.x),@((float)scrollView.contentOffset.y)]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.bi raiseUIEvent:nil event:@"sc_begin::" params:@[@((float)scrollView.contentOffset.x),@((float)scrollView.contentOffset.y)]];

}

#end if

#If Objc

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

B4ITableView * t = [B4IObjectWrapper createWrapper:[B4ITableView new ] object:tableView];
NSArray *arr=([t GetItems:indexPath.section]).object;
B4ITableCell* tc = [arr objectAtIndex:indexPath.row];

[self.bi raiseUIEvent:nil event:@"table1_selectedchanged::" params:@[@((int)indexPath.section),(tc)]];


}

#end if
#End Region