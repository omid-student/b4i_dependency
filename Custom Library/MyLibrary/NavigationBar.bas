B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
#IgnoreWarnings:19,2,12

Private Sub Process_Globals
	Public ALIGN_CENTER As Int  = 1
	Public ALIGN_LEFT As Int  = 1
	Public ALIGN_RIGHT As Int  = 1
	Private CurrentNavColor As Int = Colors.Transparent
	Public NAVIGATIONBAR_STYLE_WHITE As Int = 1
	Public NAVIGATIONBAR_STYLE_BLACK As Int = 0
End Sub

'call Show precedure in relate Page
Sub StartActivity(Page As Object)
	
	If SubExists(Page,"Show",0) Then
		CallSubDelayed(Page,"Show")
		
	Else if SubExists(Page,"Activity_Create",1) Then
		CallSubDelayed2(Page,"Activity_Create",True)
		
	End If
	
End Sub

Sub Finish
	Main.NavControl.RemoveCurrentPage
End Sub

'without animation
Sub Finish2
	Main.NavControl.RemoveCurrentPage2(False)
End Sub

'finish page with animation and dont show previous page
Sub Finish3
	HidePage(Main.NavControl,13,1,1.3)
End Sub

'finish page with animation and dont show previous page
Sub Finish4(AnimationStyle As Int,Duration As Float)
	HidePage(Main.NavControl,AnimationStyle,1,Duration)
End Sub

Sub ChangeNavigationColor(Color As Int)
	Dim no As NativeObject = Main.NavControl
	no.GetField("navigationBar").RunMethod("setBarTintColor:", Array(no.ColorToUIColor(Color)))
	CurrentNavColor	=	Color
End Sub

Sub GetNavigationColor As Int
	Return CurrentNavColor
End Sub

Sub ChangeNavigationTintColor(Color As Int)
	Dim no As NativeObject = Main.NavControl
	no.GetField("navigationBar").RunMethod("setTintColor:", Array(no.ColorToUIColor(Color)))
End Sub

Sub SetTitleColor(clr As Int)
	Dim attributes As NativeObject
	attributes = attributes.Initialize("B4IAttributedString").RunMethod("createAttributes::", _
     Array(Font.CreateNew(18), attributes.ColorToUIColor(clr)))
	Dim no As NativeObject = Main.NavControl
	no.GetField("navigationBar").RunMethod("setTitleTextAttributes:", Array(attributes))
End Sub

Sub ChangeToolbarColor(Color As Int)
	Dim no As NativeObject = Main.NavControl
	no.GetField("toolbar").SetField("barTintColor", no.ColorToUIColor(Color))
End Sub

Sub HideTabBarController(Page1 As Page)
	Dim no As NativeObject = Page1
	no.SetField("hidesBottomBarWhenPushed",True)
End Sub

'Add #PlistExtra: <key>UIViewControllerBasedStatusBarAppearance</key><false/>
Sub FullScreenApp(app As Application)
	Dim no As NativeObject = app
	no.RunMethod("setStatusBarHidden:animated:", Array(True, False))
End Sub

'Add <code>#PlistExtra: <key>UIViewControllerBasedStatusBarAppearance</key><false/></code>
'set 1 or 3 for white statusbar
Sub SetStatusBarStyleLight(app As Application,Style As Int)
	Dim no As NativeObject = app
	no.RunMethod("setStatusBarStyle:", Array(Style))
End Sub

Sub PushUpPage(ParentPage As Page,NewPage As Page)
	Dim no As NativeObject = ParentPage
	no.RunMethod("presentViewController:animated:completion:", Array(NewPage, True, Null))
End Sub

Public Sub PushDownPage(ParentPage As Page)
	Dim no As NativeObject = ParentPage
	no.RunMethod("dismissViewControllerAnimated:completion:", Array(True, Null))
End Sub

Sub MakePageTitleView(Page1 As Page,Title As String,Prompt As String,TextColor As Int)
	
	Page1.Title	=	Title
	
	Dim lbtitle As Label
	Dim lbprompt As Label
	
	If Page1.TitleView.IsInitialized = False Then
		
		Dim pn As Panel
		pn.Initialize("")
		pn.Color	=	Colors.Transparent
		pn.SetLayoutAnimated(1,1,0,0,GetDeviceLayoutValues.Width,50dip)
		
		lbtitle.Initialize("")
		lbtitle.TextColor		=	TextColor
		lbtitle.TextAlignment	=	lbtitle.ALIGNMENT_CENTER
		lbtitle.Font			=	Font.CreateNewBold(14)
		pn.AddView(lbtitle,0,2,pn.Width,25dip)
		
		lbprompt.Initialize("")
		lbprompt.TextColor		=	TextColor
		lbprompt.TextAlignment	=	lbprompt.ALIGNMENT_CENTER
		lbprompt.Font			=	Font.CreateNew(11)
		pn.AddView(lbprompt,0,20dip,pn.Width,25dip)
		
		lbtitle.Text	=	Title
		lbprompt.Text	=	Prompt
		
		Page1.TitleView	=	pn
	
	Else
		
		Dim pn As Panel
		pn	=	Page1.TitleView
		
		lbtitle		=	pn.GetView(0)
		lbprompt	=	pn.GetView(1)
		
		lbtitle.Text	=	Title
		lbprompt.Text	=	Prompt
		
	End If
	
End Sub

'add below code
'<code>#PlistExtra: <key>UIViewControllerBasedStatusBarAppearance</key><false/></code>
Sub PlaceImageOnbackNavigationbar
	
End Sub

'You can change the Style to 5 to 6,7,..
'You can change the animations style by changeing TransitionStyle to 0 to 1,2,...
Sub ShowTransparentPage(Parent As Page, NewPage As Page,Style As Int,TransitionStyle As Int)

	Dim no As NativeObject = Parent
	Dim no2 As NativeObject=NewPage

	no2.SetField("ModalTransitionStyle",TransitionStyle)
	no.SetField("providesPresentationContextTransitionStyle",True)
	no.SetField("definesPresentationContext",True)
	no2.SetField("ModalPresentationStyle",Style)
	no.RunMethod("presentModalViewController:animated:",Array(NewPage,True))

End Sub

Sub PresentPage2(Parent As Page, dialog As Page)
	Dim no As NativeObject = dialog
	no.SetField("modalTransitionStyle",1)

	Dim no2 As NativeObject = Parent
	no2.RunMethod("presentModalViewController:animated:", Array(dialog, True))
End Sub

Sub HideTransparentPage(Parent As Page)

	Dim no As NativeObject=Parent
	no.RunMethod("dismissViewControllerAnimated:completion:",Array(True,Null))
	'you can disable the animation by setting false
	
End Sub

'show normal page
Sub ShowPage2(NavigationControl As NavigationController,PageToShow As Page)
	NavigationControl.ShowPage(PageToShow)
End Sub

'Transition: 
'0 = cameraIris
'1 = cameraIrisHollowOpen
'2 = cameraIrisHollowClose
'3 = cube
'4 = alignedCube
'5 = flip,
'6 = alignedFlip
'7 = oglFlip
'8 = rotate
'9 = pageCurl
'10 = pageUnCurl
'11 = rippleEffect
'12 = suckEffect
'13 = fade
'14 = push
'Direction: 0 = FromTop, 1 = FromBottom, 2 = FromLeft, 3 = FromRight
Public Sub ShowPage(NavigationControl As NavigationController,PageToShow As Page,TransType As Int, Direction As Int,Duration As Float)
	Dim TransitionType As String
	Select TransType
		Case 0
			TransitionType = "cameraIris"
		Case 1
			TransitionType = "cameraIrisHollowOpen"
		Case 2
			TransitionType = "cameraIrisHollowClose"
		Case 3
			TransitionType = "cube"
		Case 4
			TransitionType = "alignedCube"
		Case 5
			TransitionType = "flip"
		Case 6
			TransitionType = "alignedFlip"
		Case 7
			TransitionType = "oglFlip"
		Case 8
			TransitionType = "rotate"
		Case 9
			TransitionType = "pageCurl"
		Case 10
			TransitionType = "pageUnCurl"
		Case 11
			TransitionType = "rippleEffect"
		Case 12
			TransitionType = "suckEffect"
		Case 13
			TransitionType = "fade"
		Case 14
			TransitionType = "push"

	End Select

	Dim FromDirection As String
	Select Direction
		Case 0
			FromDirection = "fromTop"
		Case 1
			FromDirection = "fromBottom"
		Case 2
			FromDirection = "fromLeft"
		Case 3
			FromDirection = "fromRight"
	End Select

	Dim no As NativeObject=Me
	no.RunMethod("trans::::",Array(NavigationControl,TransitionType,FromDirection,Duration))
	NavigationControl.ShowPage2(PageToShow,False)
	
End Sub

#if OBJC

-(void) trans: (UINavigationController*)nav :(NSString*)tp :(NSString*)from :(float)duration
{
CATransition *transition = [CATransition animation];
transition.duration = duration;
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
transition.type = tp;
transition.subtype = from;
[nav.view.layer addAnimation:transition forKey:nil];
}

#End If

'Transition: 
'0 = cameraIris
'1 = cameraIrisHollowOpen
'2 = cameraIrisHollowClose
'3 = cube
'4 = alignedCube
'5 = flip,
'6 = alignedFlip
'7 = oglFlip
'8 = rotate
'9 = pageCurl
'10 = pageUnCurl
'11 = rippleEffect
'12 = suckEffect
'13 = fade
'14 = push
'Direction: 0 = FromTop, 1 = FromBottom, 2 = FromLeft, 3 = FromRight
Public Sub HidePage(NavigationControl As NavigationController,TransType As Int, Direction As Int,Duration As Float)
	Dim TransitionType As String
	Select TransType
		Case 0
			TransitionType = "cameraIris"
		Case 1
			TransitionType = "cameraIrisHollowOpen"
		Case 2
			TransitionType = "cameraIrisHollowClose"
		Case 3
			TransitionType = "cube"
		Case 4
			TransitionType = "alignedCube"
		Case 5
			TransitionType = "flip"
		Case 6
			TransitionType = "alignedFlip"
		Case 7
			TransitionType = "oglFlip"
		Case 8
			TransitionType = "rotate"
		Case 9
			TransitionType = "pageCurl"
		Case 10
			TransitionType = "pageUnCurl"
		Case 11
			TransitionType = "rippleEffect"
		Case 12
			TransitionType = "suckEffect"
		Case 13
			TransitionType = "fade"
		Case 14
			TransitionType = "push"

	End Select

	Dim FromDirection As String
	Select Direction
		Case 0
			FromDirection = "fromTop"
		Case 1
			FromDirection = "fromBottom"
		Case 2
			FromDirection = "fromLeft"
		Case 3
			FromDirection = "fromRight"
	End Select

	Dim no As NativeObject=Me
	no.RunMethod("trans::::",Array(NavigationControl,TransitionType,FromDirection,Duration))
	NavigationControl.RemoveCurrentPage2(False)
	
End Sub

'Hide page and show next page
'Transition: 
'0 = cameraIris
'1 = cameraIrisHollowOpen
'2 = cameraIrisHollowClose
'3 = cube
'4 = alignedCube
'5 = flip,
'6 = alignedFlip
'7 = oglFlip
'8 = rotate
'9 = pageCurl
'10 = pageUnCurl
'11 = rippleEffect
'12 = suckEffect
'13 = fade
'14 = push
'Direction: 0 = FromTop, 1 = FromBottom, 2 = FromLeft, 3 = FromRight
Public Sub HidePage2(NavigationControl As NavigationController,PageToShow As Page,TransType As Int, Direction As Int,Duration As Float)
	Dim TransitionType As String
	Select TransType
		Case 0
			TransitionType = "cameraIris"
		Case 1
			TransitionType = "cameraIrisHollowOpen"
		Case 2
			TransitionType = "cameraIrisHollowClose"
		Case 3
			TransitionType = "cube"
		Case 4
			TransitionType = "alignedCube"
		Case 5
			TransitionType = "flip"
		Case 6
			TransitionType = "alignedFlip"
		Case 7
			TransitionType = "oglFlip"
		Case 8
			TransitionType = "rotate"
		Case 9
			TransitionType = "pageCurl"
		Case 10
			TransitionType = "pageUnCurl"
		Case 11
			TransitionType = "rippleEffect"
		Case 12
			TransitionType = "suckEffect"
		Case 13
			TransitionType = "fade"
		Case 14
			TransitionType = "push"

	End Select

	Dim FromDirection As String
	Select Direction
		Case 0
			FromDirection = "fromTop"
		Case 1
			FromDirection = "fromBottom"
		Case 2
			FromDirection = "fromLeft"
		Case 3
			FromDirection = "fromRight"
	End Select

	Dim no As NativeObject=Me
	no.RunMethod("trans::::",Array(NavigationControl,TransitionType,FromDirection,Duration))
	NavigationControl.RemoveCurrentPage2(True)
	
End Sub

'you can back to preivous page with drag without visible navigationbar
Sub EnableBackSliding(NavControl As NavigationController)
	Dim no As NativeObject = NavControl
	no.GetField("interactivePopGestureRecognizer").RunMethod("setDelegate:",Array(Null))
End Sub

Sub SetOrientation(landscape As Boolean)
	Dim no As NativeObject
	Dim value As Int
	If landscape Then value = 4 Else value = 1
	no.Initialize("UIDevice").RunMethod("currentDevice", Null).SetField("orientation", value)
End Sub

Sub DisableTransitionPage(Page As Page)
	Dim no As NativeObject = Main.NavControl
	no.RunMethod("pushViewController:animated:", Array (Page, False))
End Sub

'use this function in pages that have Back button
Sub ChangeBackButtonTitle(Title As String,Color As Int,Font2 As Font)
	Dim barback As BarButton
	barback.InitializeText(Title,"")
	barback.TintColor	=	Color
	barback.SetFont(Font2)
	Dim no As NativeObject = Main.NavControl
	Try
		no.GetField("navigationBar").GetField("topItem").SetField("backBarButtonItem",barback)
	Catch
	End Try
End Sub

'use this function in pages that have Back button
Sub SetBackButtonView(BarButton2 As BarButton)
	Dim no As NativeObject = Main.NavControl
	no.GetField("navigationBar").GetField("topItem").SetField("backBarButtonItem",BarButton2)
End Sub

Sub ExitApplication
	Dim No As NativeObject = Me
	No.RunMethod("ExitApplication",Null)
	#if OBJC
	- (void) ExitApplication {

	UIApplication *app = [UIApplication sharedApplication]; 
	[app performSelector:@selector(suspend)]; 
	 [NSThread sleepForTimeInterval:2.0];
	exit(0);

	}
	#End if 
End Sub

Sub ChangePageTitleStyle(Page1 As Page,Title As String,Font2 As Font,Color As Int)
	
	Dim l As Label
	l.Initialize("lbltitle1")
	l.Text			=	Title
	l.Font			=	Font2
	l.Color			=	Colors.Transparent
	l.TextAlignment	=	l.ALIGNMENT_CENTER
	l.TextColor		=	Color
	Page1.TitleView	=	GetLabelPageTitle(Title,Font2,Color,l.ALIGNMENT_CENTER)
	
End Sub

Sub GetLabelPageTitle(Title As String,Font2 As Font,Color As Int,Align As Int) As Label
	
	Dim l As Label
	l.Initialize("lbltitle1")
	l.Text			=	Title
	l.Font			=	Font2
	l.Color			=	Colors.Transparent
	l.TextAlignment	=	Align
	l.TextColor		=	Color
	Return l
	
End Sub

'add below code to project attribute
'<code>#PlistExtra:<key>UIApplicationShortcutItems</key><array><dict><key>UIApplicationShortcutItemType</key><string>[tag]</string><key>UIApplicationShortcutItemTitle</key><string>[title]</string></dict></array></code>
'
'you can below field for extra option
'<key>UIApplicationShortcutItemSubtitle</key><string>[subtitle]</string>   => for sub title menu
'<key>UIApplicationShortcutItemIconFile</key><string>[filename]</string>   => for menu icon that file should be in Special folder
'
'add below code to end of main module
'<code>	#if OBJC
'@end
'@implementation B4IAppDelegate (shortcut)
'-(void)application:(UIApplication *)application
'performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
'completionHandler:(void (^)(BOOL succeeded))completionHandler{
'B4I* bi = [b4i_main new].bi;
'[bi raiseEvent:nil event:@"application_shortcutitemclicked:" params:@[shortcutItem.type]];
'completionHandler(YES);
'}
'#End If
'</code>
Sub AddShortcut3DTouch
	
End Sub

'Minimum version should be 10 at least
'Actions is list of your actions title
'Response send to event UserNotification_Action(Response As Object)

'add below code to main module
'<code>
'#AdditionalLib: UserNotifications.framework
'#if OBJC
'#import <UserNotifications/UserNotifications.h>
'@end
'@interface b4i_main (notification) <UNUserNotificationCenterDelegate>
'@end
'@implementation b4i_main (notification)
'- (void)userNotificationCenter:(UNUserNotificationCenter *)center
'didReceiveNotificationResponse:(UNNotificationResponse *)response
'         withCompletionHandler:(void (^)(void))completionHandler {
'       B4I* bi = [b4i_main new].bi;
'[bi raiseEvent:nil event:@"usernotification_action:" params:@[response]];
'completionHandler();
'   }
'#End If
'</code>
Sub CreateNotificationWithActions(Title As String, Body As String, MillisecondsFromNow As Long,Actions As List)

	Dim ln As NativeObject
	ln = ln.Initialize("UNMutableNotificationContent").RunMethod("new", Null)
	ln.SetField("title", Title)
	ln.SetField("body", Body)
	Dim n As NativeObject
	ln.SetField("sound", n.Initialize("UNNotificationSound").RunMethod("defaultSound", Null))
	ln.SetField("categoryIdentifier", "category 1")
	Dim trigger As NativeObject
	trigger = trigger.Initialize("UNTimeIntervalNotificationTrigger").RunMethod("triggerWithTimeInterval:repeats:", Array(MillisecondsFromNow / 1000, False))
	Dim request As NativeObject
	request = request.Initialize("UNNotificationRequest").RunMethod("requestWithIdentifier:content:trigger:", _
       Array("identifer 2", ln, trigger))
	Dim NotificationCenter As NativeObject
	NotificationCenter = NotificationCenter.Initialize("UNUserNotificationCenter").RunMethod("currentNotificationCenter", Null)
	NotificationCenter.RunMethod("addNotificationRequest:", Array(request))
	
	Dim category2 As NativeObject
	category2 = category2.Initialize("UNNotificationCategory")
 
	Dim newactions As List
	newactions.Initialize
	
	For i = 0 To Actions.Size - 1
		
		Dim acceptAction As NativeObject
		acceptAction.Initialize("UNNotificationAction")
		'5 = AuthenticationRequired + Foreground
		acceptAction = acceptAction.RunMethod("actionWithIdentifier:title:options:", Array(Actions.Get(i), Actions.Get(i), 5))
		newactions.Add(acceptAction)
		
	Next
	
	Dim intentIdentifiers As List = Array()
	category2 = category2.RunMethod("categoryWithIdentifier:actions:intentIdentifiers:options:", _
       Array("category 1", newactions, intentIdentifiers, 1))
	Dim NotificationCenter As NativeObject
 
	NotificationCenter = NotificationCenter.Initialize("UNUserNotificationCenter").RunMethod("currentNotificationCenter", Null)
	Dim Set As NativeObject
	Set = Set.Initialize("NSSet").RunMethod("setWithObject:", Array(category2))
	NotificationCenter.RunMethod("setNotificationCategories:", Array(Set))

	NotificationCenter.SetField("delegate", Me)
	
End Sub

'Minimum version should be 10 at least
'Actions is list of your actions title
'Response send to event UserNotification_Action(Response As Object)
'Possible for remote notification
'add click_action key notification key with category id
'example: iosalert.Put("click_action", "category 1")

'add below code to main module
'<code>
'#AdditionalLib: UserNotifications.framework
'#if OBJC
'#import <UserNotifications/UserNotifications.h>
'@end
'@interface b4i_main (notification) <UNUserNotificationCenterDelegate>
'@end
'@implementation b4i_main (notification)
'- (void)userNotificationCenter:(UNUserNotificationCenter *)center
'didReceiveNotificationResponse:(UNNotificationResponse *)response
'         withCompletionHandler:(void (^)(void))completionHandler {
'       B4I* bi = [b4i_main new].bi;
'[bi raiseEvent:nil event:@"usernotification_action:" params:@[response]];
'completionHandler();
'   }
'#End If
'</code>
Sub SetNotificationActions(ActionsList As List)
 
	Dim category2 As NativeObject
	category2 = category2.Initialize("UNNotificationCategory")
	'create a list with the action identifiers and titles: <--------------------------------------------
	Dim actions As List
	actions.Initialize
	
	For i = 0 To ActionsList.Size - 1
		
		Dim acceptAction As NativeObject
		acceptAction.Initialize("UNNotificationAction")
		'5 = AuthenticationRequired + Foreground
		acceptAction = acceptAction.RunMethod("actionWithIdentifier:title:options:", Array(ActionsList.Get(i), ActionsList.Get(i), 5))
		actions.Add(acceptAction)
		
	Next
 
	Dim intentIdentifiers As List = Array()
	category2 = category2.RunMethod("categoryWithIdentifier:actions:intentIdentifiers:options:", _
       Array("category 1", actions, intentIdentifiers, 1))
	Dim NotificationCenter As NativeObject
 
	NotificationCenter = NotificationCenter.Initialize("UNUserNotificationCenter").RunMethod("currentNotificationCenter", Null)
	Dim Set As NativeObject
	Set = Set.Initialize("NSSet").RunMethod("setWithObject:", Array(category2))
	NotificationCenter.RunMethod("setNotificationCategories:", Array(Set))
	
	NotificationCenter.SetField("delegate", Me)
	
End Sub

Private Sub CreateAction (Identifier As String, Title As String) As Object
	Dim acceptAction As NativeObject
	acceptAction.Initialize("UNNotificationAction")
	'5 = AuthenticationRequired + Foreground
	acceptAction = acceptAction.RunMethod("actionWithIdentifier:title:options:", Array(Identifier, Title, 5))
	Return acceptAction
End Sub

'call Page1_BarButtonClick event when user click on label
Public Sub CreateBarButton(Module As Object,Title As String,FontFamily As Font,TextColor As Int,Tag As Object) As BarButton
	
	Dim lbl As Label
	lbl.Initialize("lbl")
	lbl.TextColor	=	TextColor
	lbl.Font		=	FontFamily
	lbl.Text		=	Title
	lbl.Tag			=	CreateMap("tag":Tag,"module":Module)
	lbl.Width		=	40dip
	
	Dim bar2 As BarButton
	bar2.InitializeCustom(lbl)
	Return bar2
	
End Sub

Private Sub lbl_Click
	
	Dim lb As Label
	lb	=	Sender
	
	Dim map As Map
	map	=	lb.Tag
	
	CallSubDelayed2(map.Get("module"),"Page1_BarButtonClick",map.Get("tag"))
	
End Sub

'set tag to NavigationController with value "portrait" or "landscape"
'if you set landscape for tag,app can rotate to landscape
'
'add below code to main module
'<code>
'#if OBJC
'@end
'@interface UINavigationController (B4IResize)
'
'@end
'@implementation UINavigationController (B4IResize)
'- (BOOL)shouldAutorotate
'{
'	NSDictionary* map = [B4IObjectWrapper getMap:self];
'	NSString* tag = map[@"tag"];
'	If ([tag isEqualToString:@"portrait"])
'		Return NO;
'	Else
'		Return YES;
'}
'
'#End If
'</code>
Public Sub HandleRotateNavigation
	
End Sub

Public Sub CreateNotificationWithContent(Title As String, subTitle As String, Body As String, ImageURL As String, Identifier As String, Category As String, MillisecondsFromNow As Long)
	Dim ln As NativeObject
	ln = ln.Initialize("UNMutableNotificationContent").RunMethod("new", Null)
	ln.SetField("title", Title)
	If subTitle <> "" Then ln.SetField("subtitle", subTitle)


	If ImageURL <> "" Then
		Dim imageNSURL As NativeObject
		imageNSURL = imageNSURL.Initialize("NSURL").RunMethod("fileURLWithPath:",Array(ImageURL))
		Dim attachment As NativeObject = Me
		ln.SetField("attachments", attachment.RunMethod("createAttachment:",Array(imageNSURL)))
	End If


	ln.SetField("body", Body)
	Dim n As NativeObject
	ln.SetField("sound", n.Initialize("UNNotificationSound").RunMethod("defaultSound", Null))
	If Category <> "" Then ln.SetField("categoryIdentifier", Category)
	Dim trigger As NativeObject
	trigger = trigger.Initialize("UNTimeIntervalNotificationTrigger").RunMethod("triggerWithTimeInterval:repeats:", Array(MillisecondsFromNow / 1000, False))
	Dim request As NativeObject
	request = request.Initialize("UNNotificationRequest").RunMethod("requestWithIdentifier:content:trigger:", _
       Array(Identifier, ln, trigger))
	Dim NotificationCenter As NativeObject
	NotificationCenter = NotificationCenter.Initialize("UNUserNotificationCenter").RunMethod("currentNotificationCenter", Null)
	NotificationCenter.RunMethod("addNotificationRequest:", Array(request))
End Sub

#if OBJC
-(NSArray *) createAttachment: (NSURL *)imgurl{
    NSError *error = nil;
    UNNotificationAttachment *attachment;
    attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageID"
                                                          URL:imgurl
                                                      options:nil
                                                        error:&error];
    NSArray *arr = @[attachment];
    return arr;
}

#import <UserNotifications/UserNotifications.h>
@end
@interface b4i_main (notification) <UNUserNotificationCenterDelegate>
@end
@implementation b4i_main (notification)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
        completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound );
   }
   

#End If

Public Sub IsDarkMode As Boolean
	Dim app As Application
	If app.OSVersion < 13 Then Return False
	Dim no As NativeObject = app.KeyController
	Return no.GetField("traitCollection").GetField("userInterfaceStyle").AsNumber = 2
End Sub