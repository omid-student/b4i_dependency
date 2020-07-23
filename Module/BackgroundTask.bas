Type=Class
Version=2.51
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@

'VERSION:  1.10

Sub Class_Globals
	Private mTaskname As String
	Private mModule As Object
	Private mResult As Object
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Subname As String,Module As Object,Params As List)
	
	mTaskname=Subname
	mModule=Module
	mResult=Null
	
	If Params.Size=0 Then
		No(Me).RunMethod("RunThread::",Array(Module,Subname))
	Else If Params.Size=1 Then
		No(Me).RunMethod("RunThread2:::",Array(Module,Subname,Params.Get(0)))
	Else If Params.Size=2 Then
		No(Me).RunMethod("RunThread3::::",Array(Module,Subname,Params.Get(0),Params.Get(1)))
	End If
	
End Sub



Private Sub No(obj As NativeObject) As NativeObject
	Return obj
End Sub

Public Sub setResult(Result As Object) As Object
	mResult=Result
End Sub


Private Sub bgDone
	If SubExists(mModule,mTaskname & "_Done",1) Then
		CallSub2(mModule,mTaskname & "_Done",mResult)
	Else
		CallSub(mModule,mTaskname & "_Done")
	End If
End Sub

#If OBJC 

-(void)RunThread: (NSObject*)m :(NSString*)sub
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub:self.bi :m :(sub)];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone"];
		
    });
});
}

-(void)RunThread2: (NSObject*)m :(NSString*)sub :(id) param1
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub2:self.bi :m :(sub) :param1];

    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone" ];
    });
});
}


-(void)RunThread3: (NSObject*)m :(NSString*)sub :(id) param1 :(id)param2
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
	[self.__c CallSub3:self.bi :m :(sub) :param1 :param2];

    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone" ];
    });
});
}

-(void)RunThread4: (NSObject*)m :(NSString*)sub :(NSObject*) param1 :(id)param2 
{


dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

	B4IStaticModule *objB4I=m;
	[objB4I.bi raiseEvent:nil event:(sub) params:@[(param1),(param2)]];
	
	NSLog(sub);
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.__c CallSub:self.bi :self :@"bgdone"];
    });
});
}

#End if