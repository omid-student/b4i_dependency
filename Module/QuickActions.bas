B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=3
@EndOfDesignText@
'Code module

Private Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.

End Sub

Sub StartSettings
	Dim No As NativeObject = Me
	No.RunMethod("SetNew",Null)
End Sub

Sub ActiveSettings
	Dim No As NativeObject = Me
	No.RunMethod("SetOld",Null)
End Sub

Sub InactiveSettings
	Dim No As NativeObject = Me
	No.RunMethod("SetNew",Null)
	No.RunMethod("AddObserver",Null)
End Sub

Private Sub A
	CallSub(Main,"Application_Active")
End Sub

Private Sub I
	CallSub(Main,"Application_Inactive")
End Sub

Private Sub F
	CallSub(Main,"Application_Foreground")
End Sub

Private Sub B
	CallSub(Main,"Application_Background")
End Sub

Private Sub S (Typee As String)
	CallSub2(Main,"Application_ShortcutItemClicked",Typee)
End Sub
#If OBJC

id LastDelegate;
BOOL hasObserver;

-(void)AddObserver{
if (!hasObserver){
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Active) name:UIApplicationDidBecomeActiveNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Foreground) name:UIApplicationWillEnterForegroundNotification object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Background) name:UIApplicationDidEnterBackgroundNotification object:nil];
hasObserver = YES;
}
}

-(void)Active{
[self.bi raiseEvent:nil event:@"a" params:nil];
}
-(void)Foreground{
[self.bi raiseEvent:nil event:@"f" params:nil];
}
-(void)Background{
[self.bi raiseEvent:nil event:@"b" params:nil];
}

-(void)SetNew{
LastDelegate = [UIApplication sharedApplication].delegate;
[UIApplication sharedApplication].delegate = self;
}

-(void)SetOld{
[UIApplication sharedApplication].delegate = LastDelegate;;
}

-(void)application:(UIApplication *)application 
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem 
completionHandler:(void (^)(BOOL succeeded))completionHandler{

[self.bi raiseEvent:nil event:@"s:" params:@[shortcutItem.type]];
completionHandler(YES);
}
#End If