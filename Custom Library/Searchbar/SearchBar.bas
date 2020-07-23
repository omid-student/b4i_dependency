B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
#Event: TextChanged (Text As String)
#Event: OnSearchButton(Text As String)
#Event: OnCancelButton

Private Sub Class_Globals
	Private mCallback As Object
	Private mEventName As String
	Private pgSearchResult As Page
	Private SearchController As NativeObject
End Sub

'Initializes the object and sets the module and sub that will handle the ItemClick event
Public Sub Initialize (Callback As Object, EventName As String)

	mCallback	=	Callback
	mEventName	=	EventName
	
	pgSearchResult.Initialize("pgSearchResult")
	SearchController	=	NO(Me).RunMethod("sc",Null)
	
	pgSearchResult.RootPanel.Color	=	Colors.ARGB(80,20,20,20)
	
End Sub

Sub setBackgroundColor(Color As Int)
	SearchController.GetField("searchBar").SetField("barTintColor",SearchController.ColorToUIColor(Color))
End Sub

'Adds the view to the parent. The parent can be an Activity or Panel.
Public Sub AddToParent(Parent As Panel)
	Parent.RemoveAllViews
	Dim v As View	=	NO(SearchController).GetField("searchBar")
	v.Width			=	Parent.Width
	v.Height		=	50
	Parent.AddView(v,0,0,Parent.Width,v.Height)
	SearchController_TextChanged("")
End Sub

Public Sub HideSearchView
	SearchController.SetField("active",False)
End Sub

Public Sub ShowSearchView
	SearchController.SetField("active",True)
End Sub

Public Sub Searching As Boolean
	Return SearchController.GetField("active").AsBoolean
End Sub

Private Sub SearchController_TextChanged (New As String)
	
	If SubExists(mCallback,mEventName & "_textchanged",1) Then
		CallSub2(mCallback,mEventName & "_textchanged",New)
	End If
	
End Sub

Private Sub SearchController_OnButton (Text As String)
	
	HideSearchView
	
	If SubExists(mCallback,mEventName & "_onsearchbutton",1) Then
		CallSub2(mCallback,mEventName & "_onsearchbutton",Text)
	End If
	
End Sub

Private Sub SearchController_OnCancelButton (Text As String)

	HideSearchView
	
	If SubExists(mCallback,mEventName & "_oncancelbutton",0) Then
		CallSub(mCallback,mEventName & "_oncancelbutton")
	End If
	
End Sub

Private Sub NO(obj As NativeObject) As NativeObject
	Return obj
End Sub

#If OBJC

-(UISearchController*)sc
{
	UISearchController* sv =[[UISearchController alloc] initWithSearchResultsController:(self._pgsearchresult).object];
	//sv.searchResultsUpdater =(self._page2).object;
	sv.dimsBackgroundDuringPresentation = YES;
	//sv.searchBar.scopeButtonTitles	= @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
	//NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
	//searchController.searchBar.placeholder = "Search for Title"
	sv.definesPresentationContext		=	YES;
	sv.delegate							=	self;
	sv.searchBar.delegate				=	self;
	sv.extendedLayoutIncludesOpaqueBars	=	YES;
	return sv;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.bi raiseUIEvent:nil event:@"searchcontroller_textchanged:" params:@[(searchText)]];;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 	NSString* newText = searchBar.text;
    [self.bi raiseUIEvent:nil event:@"searchcontroller_onbutton:" params:@[(newText)]];;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
 	NSString* newText = searchBar.text;
    [self.bi raiseUIEvent:nil event:@"searchcontroller_oncancelbutton:" params:@[(newText)]];;
}

#End if