B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
'Class module
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize

End Sub

Sub HideScrollbar(WebView1 As WebView)
	Dim no As NativeObject = WebView1
	no.GetField("scrollView").SetField("showsHorizontalScrollIndicator", False)
	no.GetField("scrollView").SetField("showsVerticalScrollIndicator", False)
End Sub

Sub TransparentBG(WebView1 As WebView)
	Dim no As NativeObject = WebView1
	no.SetField("opaque", False)
End Sub

Sub DisableScollbar(WebView1 As WebView)
	Dim no As NativeObject = WebView1
	no.GetField("scrollView").SetField("scrollEnabled", False)
End Sub

Sub GoBack(WebView1 As WebView)
	Dim no As NativeObject = WebView1
	If no.RunMethod("canGoBack", Null).AsBoolean = True Then
		no.RunMethod("goBack", Null)
	End If
End Sub

Sub ClearCache
	Dim no As NativeObject
	no.Initialize("NSURLCache").RunMethod("sharedURLCache", Null).RunMethod("removeAllCachedResponses", Null)
End Sub

Sub InlineJavaScript(WebView1 As WebView,javascript As String) As String
	Dim no As NativeObject = WebView1
	no	=	no.RunMethod("stringByEvaluatingJavaScriptFromString:", Array(javascript))
	Return no.AsString
End Sub

'example
'<code>
'GetElementJavascript("document.documentElement.outerHTML")
'</code>
Sub GetElementJavascript(WebView1 As WebView,command As String) As String
	Dim no As NativeObject = WebView1
	Return no.RunMethod("stringByEvaluatingJavaScriptFromString:", Array(command)).AsString
End Sub