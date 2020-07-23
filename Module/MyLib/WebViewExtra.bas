Type=StaticCode
Version=1.8
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals

End Sub

Sub HideScrollbar(WebView1 As WebView)
	Dim no As NativeObject = WebView1
	no.GetField("scrollView").SetField("showsHorizontalScrollIndicator", False)
	no.GetField("scrollView").SetField("showsVerticalScrollIndicator", False)
End Sub

Sub BackgroundTransparent(WebView1 As WebView)
Dim no As NativeObject = WebView1
no.SetField("opaque", False)
End Sub

Sub GoBack(wv As WebView)
Dim no As NativeObject = wv
  If no.RunMethod("canGoBack", Null).AsBoolean = True Then
   no.RunMethod("goBack", Null)
  End If
End Sub

Sub ExecuteJavascript(WebView1 As WebView,Code As String)
Dim no As NativeObject = WebView1
no.RunMethod("stringByEvaluatingJavaScriptFromString:", Array(Code))
End Sub