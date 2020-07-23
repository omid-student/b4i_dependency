Type=Class
Version=2.51
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@

Sub Class_Globals
	Private Device, Session, MovieOutput, LLCam  As NativeObject
	Private mHandler As Object
	Private mEventName As String
	Private mFolder,mFileName As String
	Private misRecording As Boolean=False
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Handler As Object, EventName As String, LLCamera As LLCamera)
	mHandler=Handler
	mEventName=EventName
	
	If LLCamera.IsInitialized Then
		LLCam=LLCamera
		Device=LLCam.GetField("device")
		Session=LLCam.GetField("session")
		
		Dim audioOutput As NativeObject=no(Me).RunMethod("audioout",Null)
		Session.RunMethod("addInput:",Array(audioOutput))
		MovieOutput=no(Me).RunMethod("output:",Array(Session))
		
	End If
End Sub

Public Sub StartRecording (Folder As String, FileName As String)
	If misRecording=False Then
		mFolder=Folder
		mFileName=FileName
		Dim URL As Object=no(Me).RunMethod("url:",Array(File.Combine(Folder,FileName)))
		MovieOutput.RunMethod("startRecordingToOutputFileURL:recordingDelegate:",Array(URL,Me))
		MovieOutput.RunMethod("release",Null)
		misRecording=True
		Log("recording")
	End If
End Sub

Public Sub StopRecording
	MovieOutput.RunMethod("stopRecording",Null)
	misRecording=False
	Log("Stop")
End Sub

Private Sub no(Obj As NativeObject) As NativeObject
	Return Obj
End Sub

Private Sub ll_recordfinish(Success As Boolean)
	If Success Then
		CallSubDelayed3(mHandler,mEventName & "_RecordingEnd",mFolder,mFileName)
	Else
		CallSubDelayed(mHandler,mEventName & "_RecordingFailed")
	End If
End Sub

Public Sub getIsRecording As Boolean
	Return misRecording
End Sub

#if OBJC

-(AVCaptureDeviceInput *)audioout{
AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	NSError *error = nil;
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:nil];
return audioInput;
}

-(CMTime)dur :(float)total :(int)frame
{
CMTime maxDuration = CMTimeMakeWithSeconds(total,frame);
return maxDuration;

}

-(AVCaptureMovieFileOutput*)output :(AVCaptureSession*) session
{
AVCaptureMovieFileOutput *MovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
if ([session canAddOutput:MovieFileOutput])
		[session addOutput:MovieFileOutput];
		NSLog(@"added");
return MovieFileOutput;
}

-(NSURL*)url :(NSString*) outputPath
{
NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
return outputURL;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
	  fromConnections:(NSArray *)connections
				error:(NSError *)error
{

	//NSLog(@"didFinishRecordingToOutputFileAtURL - enter");
	
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr)
	{
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
		{
            RecordedSuccessfully = [value boolValue];
			
        }
    }
	[self.bi raiseEvent:nil event:@"ll_recordfinish:" params:@[@((BOOL)RecordedSuccessfully)]];
			
}
#end if