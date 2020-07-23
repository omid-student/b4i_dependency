B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
Private Sub Class_Globals
	Private Color_s() As Int
	Private Orientation_ As String
End Sub

'Orientation support:
'LEFT_RIGHT
'RIGHT_LEFT
'TOP_LEFT
'BOTTOM_RIGHT
Public Sub Initialize(Orientation As String,Color() As Int)
	Color_s			=	Color
	Orientation_	=	Orientation
End Sub

Sub Apply(View As View)
	
	Dim NaObj As NativeObject = Me
	
	If Color_s.Length = 4 Then
		NaObj.RunMethod("SetGradient4:::::::",Array(View,NaObj.ColorToUIColor(Color_s(0)),NaObj.ColorToUIColor(Color_s(1)),NaObj.ColorToUIColor(Color_s(2)),NaObj.ColorToUIColor(Color_s(3)),Orientation_, False))
	End If
	
	If Color_s.Length = 3 Then
		NaObj.RunMethod("SetGradient3:::::",Array(View,NaObj.ColorToUIColor(Color_s(0)),NaObj.ColorToUIColor(Color_s(1)),NaObj.ColorToUIColor(Color_s(2)),Orientation_, False))
	End If
	
	If Color_s.Length = 2 Then
		NaObj.RunMethod("SetGradient2::::",Array(View,NaObj.ColorToUIColor(Color_s(0)),NaObj.ColorToUIColor(Color_s(1)),NaObj.ColorToUIColor(Color_s(2)),Orientation_, False))
	End If
	
End Sub

#If OBJC
- (void)SetGradient4: (UIView*) View :(UIColor*) Color1 :(UIColor*) Color2 :(UIColor*) Color3 :(UIColor*) Color4 :(NSString*)orientation :(BOOL) replace{
   CAGradientLayer *gradient = [CAGradientLayer layer];
   gradient.colors = [NSArray arrayWithObjects:(id)Color1.CGColor, (id)Color2.CGColor, (id)Color3.CGColor , (id)Color4.CGColor , nil];
   gradient.frame = View.bounds;
   
   if ([orientation isEqualToString: @"LEFT_RIGHT"]) {
   	gradient.startPoint = CGPointMake(0.0, 0.5);
   	gradient.endPoint = CGPointMake(1.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"RIGHT_LEFT"]) {
   	gradient.startPoint = CGPointMake(1.0, 0.5);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"TOP_LEFT"]) {
   	gradient.startPoint = CGPointMake(0, 0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"BOTTOM_RIGHT"]) {
   	gradient.startPoint = CGPointMake(1.0, 1.0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if (replace)
     [View.layer replaceSublayer:View.layer.sublayers[0] with:gradient];
   else
     [View.layer insertSublayer:gradient atIndex:0];
	 
}
#end if

#If OBJC
- (void)SetGradient3: (UIView*) View :(UIColor*) Color1 :(UIColor*) Color2 :(UIColor*) Color3 :(NSString*)orientation :(BOOL) replace{
   CAGradientLayer *gradient = [CAGradientLayer layer];
   gradient.colors = [NSArray arrayWithObjects:(id)Color1.CGColor, (id)Color2.CGColor, (id)Color3.CGColor , nil];
   gradient.frame = View.bounds;
   
   if ([orientation isEqualToString: @"LEFT_RIGHT"]) {
   	gradient.startPoint = CGPointMake(0.0, 0.5);
   	gradient.endPoint = CGPointMake(1.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"RIGHT_LEFT"]) {
   	gradient.startPoint = CGPointMake(1.0, 0.5);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"TOP_LEFT"]) {
   	gradient.startPoint = CGPointMake(0, 0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"BOTTOM_RIGHT"]) {
   	gradient.startPoint = CGPointMake(1.0, 1.0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if (replace)
     [View.layer replaceSublayer:View.layer.sublayers[0] with:gradient];
   else
     [View.layer insertSublayer:gradient atIndex:0];
	 
}
#end if

#If OBJC
- (void)SetGradient2: (UIView*) View :(UIColor*) Color1 :(UIColor*) Color2 :(UIColor*) Color3 :(NSString*)orientation :(BOOL) replace{
   CAGradientLayer *gradient = [CAGradientLayer layer];
   gradient.colors = [NSArray arrayWithObjects:(id)Color1.CGColor, (id)Color2.CGColor, (id)Color3.CGColor , nil];
   gradient.frame = View.bounds;
   
   if ([orientation isEqualToString: @"LEFT_RIGHT"]) {
   	gradient.startPoint = CGPointMake(0.0, 0.5);
   	gradient.endPoint = CGPointMake(1.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"RIGHT_LEFT"]) {
   	gradient.startPoint = CGPointMake(1.0, 0.5);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"TOP_LEFT"]) {
   	gradient.startPoint = CGPointMake(0, 0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if ([orientation isEqualToString: @"BOTTOM_RIGHT"]) {
   	gradient.startPoint = CGPointMake(1.0, 1.0);
   	gradient.endPoint = CGPointMake(0.0, 0.5);
   }
   
   if (replace)
     [View.layer replaceSublayer:View.layer.sublayers[0] with:gradient];
   else
     [View.layer insertSublayer:gradient atIndex:0];
	 
}
#end if