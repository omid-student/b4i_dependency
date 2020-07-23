Type=Class
Version=4.3
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
#DesignerProperty: Key: filename, DisplayName: Filename in DirAsset, FieldType: String,, DefaultValue:  ,Description: filename of svg file in asset folder.
#DesignerProperty: Key: fit, DisplayName: Fit Mode, FieldType: Boolean, DefaultValue: True, Description: show fit picture in parent view.

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As WeakRef
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Private svg As SVG
	Private img As ImageView
	Private pb As Panel
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)
	mBase.Value = Base
    pb = Base
	mBase = Base
	Base.Color = Colors.Transparent
	svg.Initialize(File.DirAssets,Props.Get("filename"))
 
	Base.SetBorder(0,Colors.Transparent,0)
	
	img.Initialize("img")
	Base.AddView(img,0,0,Base.Width,Base.Height)
	
	
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)

	img.Bitmap	=	svg.Export(pb.Width,pb.Height)
	
End Sub

Sub img_Click
	img.ContentMode	=	img.MODE_FIT
End Sub

Public Sub GetBase As Panel
	Return mBase.Value
End Sub

Sub ResizeBitmap(bmp As Bitmap, scale As Float) As Bitmap
	Dim img As ImageView
	img.Initialize("")
	img.Width = bmp.Width * scale
	img.Height = bmp.Height * scale
	Dim cvs As Canvas
	cvs.Initialize(img)
	cvs.DrawBitmap(bmp, cvs.TargetRect)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Release
	Return res
End Sub