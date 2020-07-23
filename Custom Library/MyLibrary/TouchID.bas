B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: OK
#Event: Error(Description As String)

Private Sub Class_Globals
	Private mo As Object
	Private evt As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
'add Ok event for verify touchid and Error for unverify touch
Public Sub Initialize(Module As Object,Event As String)
	mo	= Module
	evt = Event
End Sub

Sub ShowTouchID
	Dim noMe As NativeObject = Me
	noMe.RunMethod("TouchID:::",Array(Me,"TouchOK","TouchFail"))
End Sub

Private Sub TouchOK
	CallSubDelayed(mo,evt & "_ok")
End Sub

Private Sub TouchFail(ErrorDescription As String)
	CallSubDelayed2(mo,evt & "_error",ErrorDescription)
End Sub

#If OBJC

#import <LocalAuthentication/LocalAuthentication.h>

-(void)TouchID :(NSObject*)handler :(NSString*) subnameok :(NSString*) subnamefail
{
LAContext *myContext = [[LAContext alloc] init];
NSError *authError = nil;
NSString *myLocalizedReasonString = @"Used for quick and secure access to the test app";
if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
[myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
localizedReason:myLocalizedReasonString
reply:^(BOOL success, NSError *error) {
if (success) {
[self.__c CallSubDelayed:self.bi :handler :(subnameok)];
} else {
[self.__c CallSubDelayed2:self.bi :handler :(subnamefail) :(error.localizedDescription)];
}
}];
} else {
[self.__c CallSubDelayed2:self.bi :handler :(subnamefail) :(authError.localizedDescription)];

}
}


#End If
