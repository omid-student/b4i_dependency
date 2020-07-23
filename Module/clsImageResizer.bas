Type=Class
Version=3.5
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private pnlBorder As Panel
	Private pnlMain As Panel
	Public BorderSize As Int=2dip
	Private CornerSize As Int=20dip
	Public img As ImageView
	
	Private ImgBytes() As Byte
	Private CornerLU As Panel
	Private CornerLD As Panel
	Private CornerRU As Panel
	Private CornerRD As Panel
	
	Private grLU, grLD, grRU, grRD As GestureRecognizer
	Private grImg As GestureRecognizer
	Private grBorder As GestureRecognizer
	Private grMain As GestureRecognizer
	Private CornerColor As Int=Colors.Red
	Private BorderColor As Int=Colors.Red
	
	Private curx, cury As Float
	Private startWidth, StartHeight, StartFontSize  As Float
	
	Private mResizerVisible As Boolean=True
	
	Private nome As NativeObject=Me
	
	Private zeroPointX, ZeroPointY As Float
	Private Rotated As Boolean=False
	Private RotAngle As Float
	Private RotRadians As Float
	Private LastRotation As Float
	Private mscale As Float=1.0
	Private x1,y1 As Float
	
	Private mBitmap As Bitmap
	Private mName As String
	
	Private LastLocation As Object
	Private DeltaAngle As Float
	Private prevPoint As Object
	
	Type IMGResizerAttributes(StikerName As String, Bitmap As Object,Width As Float, Height As Float, RotationAngle As Float, X As Float, Y As Float)
	Private mAttributes As IMGResizerAttributes
	Private mEventName As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(EventName As String,Width As Int, Height As Int)
		img.Initialize("img")
		mEventName=EventName
		
		
		
		pnlMain.Initialize("pnlMain")
		
		pnlBorder.Initialize("pnlBorder")
		pnlBorder.SetBorder(BorderSize,BorderColor,0)
		
		
		CornerLU.Initialize("CornerLU")
		CornerLD.Initialize("CornerLD")
		CornerRU.Initialize("CornerRU")
		CornerRD.Initialize("CornerRD")
		
		CornerLU.Color=CornerColor
		CornerLU.Width=CornerSize
		CornerLU.Height=CornerSize
		
		CornerLD.Color=CornerColor
		CornerLD.Width=CornerSize
		CornerLD.Height=CornerSize
		
		CornerRU.Color=CornerColor
		CornerRU.Width=CornerSize
		CornerRU.Height=CornerSize
		
		CornerRD.Color=CornerColor
		CornerRD.Width=CornerSize
		CornerRD.Height=CornerSize
		
		grRD.Initialize("grRD",Me,CornerRD)
		grRD.AddPanGesture(1,1)
		grLU.Initialize("grLU",Me,CornerLU)
		grLU.AddPanGesture(1,1)

		grImg.Initialize("grImg",Me,img)
		grImg.AddPanGesture(1,2)
		grImg.AddPinchGesture
		grImg.AddRotationGesture
		
		'grMain.Initialize("grMain",Me,pnlMain)
		'grMain.AddPanGesture(1,2)
		
		'grBorder.Initialize("grBorder",Me,pnlBorder)
		'grBorder.AddPanGesture(1,1)
		'grBorder.AddPinchGesture
		'grBorder.AddRotationGesture
		pnlMain.AddView(pnlBorder,0,0,10,10)
		pnlMain.AddView(img,0,0,5,5)
		pnlMain.AddView(CornerRD,0,0,CornerSize,CornerSize)
		pnlMain.AddView(CornerLU,0,0,CornerSize,CornerSize)
		pnlMain.AddView(CornerRU,0,0,CornerSize,CornerSize)
		pnlMain.AddView(CornerLD,0,0,CornerSize,CornerSize)
		
		Resize(Width,Height)
		zeroPointX=img.Width/2
		ZeroPointY=img.Height/2
		img.BringToFront
		Dim x,y As Float
		
		x=img.Left+img.Width-OBJC.GetCenter(img).x
		y=img.Top+img.Height-OBJC.GetCenter(img).y
		'x=img.Left-OBJC.GetCenter(img).X
		'y=img.Top-OBJC.GetCenter(img).Y
		DeltaAngle= ATan2(y,x)
		
		
		
		
End Sub

Public Sub Resize(width As Float, Height As Float)
		
		img.Height=Height
		img.width=width
		pnlBorder.width=img.width+(2*BorderSize)+2dip
		pnlBorder.Height=img.Height+(2*BorderSize)+2dip
		
		pnlMain.width=img.width+(2*CornerSize)+(BorderSize*2)
		pnlMain.Height=img.Height+(2*CornerSize)+(BorderSize*2)
		img.Left=CornerSize+BorderSize+1dip
		img.Top=CornerSize+BorderSize+1dip
		pnlBorder.Top=img.Top-BorderSize-1dip
		pnlBorder.Left=img.Left-BorderSize-1dip
		
		CornerRD.Top=pnlBorder.Top+pnlBorder.Height
		CornerRD.Left=pnlBorder.Left+pnlBorder.width
		CornerLU.Top=0
		CornerLU.Left=0
		CornerRU.Top=0
		CornerRU.Left=pnlBorder.Left+pnlBorder.width
		CornerLD.Top=pnlBorder.Top+pnlBorder.Height
		CornerLD.Left=0
		
		'OBJC.SetCenter(pnlMain,p)
		
		img.BringToFront
End Sub

Public Sub ResizeRotate(r As Rect)
		Dim LeftDif,TopDif,WidthDif,HeightDif As Float
		LeftDif=r.Left-img.Left
		TopDif=r.Top-img.Top
		WidthDif=r.Right-img.Width
		HeightDif=r.Bottom-img.Height
		
		Log(LeftDif)
		
		pnlMain.Left=pnlMain.Left-LeftDif
		pnlMain.top=pnlMain.Top-TopDif
		pnlMain.Width=pnlMain.Width-WidthDif
		pnlMain.Height=pnlMain.height-HeightDif
		
		'pnlMain.Width=img.Width+(2*CornerSize)+(BorderSize*2)
		'pnlMain.Height=img.Height+(2*CornerSize)+(BorderSize*2)
		'img.Left=CornerSize+BorderSize+1dip
		'img.Top=CornerSize+BorderSize+1dip
		'pnlBorder.Top=img.Top-BorderSize-1dip
		'pnlBorder.Left=img.Left-BorderSize-1dip
		
		'CornerRD.Top=pnlBorder.Top+pnlBorder.Height
		'CornerRD.Left=pnlBorder.Left+pnlBorder.Width
		'CornerLU.Top=0
		'CornerLU.Left=0
		
		img.BringToFront
End Sub

Public Sub getAsView As Panel
Return pnlMain
End Sub

Public Sub getBitmap As Bitmap
Return mBitmap
End Sub
Public Sub setBitmap (Image As Bitmap)
mBitmap=Image
img.Bitmap=Image

'Dim out As OutputStream
'out.InitializeToBytesArray(0)
'img.Bitmap.WriteToStream(out,100,"JPEG")
'ImgBytes=out.ToBytesArray

ImgBytes=nome.NSDataToArray(nome.RunMethod("compressImage:",Array(img.Bitmap)))
End Sub

Public Sub getImage As String
Return mName
End Sub
Public Sub setImage (Name As String)
img.Bitmap=LoadBitmap(File.DirAssets,Name)
mBitmap=img.Bitmap
mName=Name
End Sub





Private Sub grRD_pan(state As Int, att As Pan_Attributes)
Dim width, height As Float
Dim old As Float

If state= grRD.STATE_Begin Then
curx=att.x
cury=att.Y
'prevPoint=nome.MakePoint(att.X,att.Y)
Else If state= grRD.STATE_Changed Then


'prevPoint=nome.RunMethod("ResizeView:::",Array(att.Obj,pnlMain,prevPoint))

'Return

'width=img.width+(att.x-curx)
'height=img.height+(att.x-curx)

width=img.width+((att.x-curx)*2)
Dim ratio As Float=width/img.width
'height=img.height+((att.x-curx)*2)
height=img.height*ratio

Dim maxsize As Boolean

If width<50dip Then 
maxsize=True
Else
maxsize=False
End If
If height<50dip Then
maxsize=True 
Else
maxsize=False
End If

If Not(maxsize) Then
pnlMain.Left=pnlMain.Left-(att.x-curx)
pnlMain.Top=pnlMain.Top-(att.x-curx)
Resize(width,height)
End If


grLU_pan(state,att)

Else If state=grImg.STATE_End Then
RotRadians=nome.RunMethod("getAngle:",Array(pnlMain)).AsNumber

End If

End Sub

Private Sub grLU_pan(state As Int,att As Pan_Attributes)
Dim rr As Rect
If state= grLU.STATE_Begin Then
curx=att.X
cury=att.Y
Else If state= grLU.STATE_Changed Then
''rr=nome.RunMethod("CenterRotate::",Array(img,nome.MakePoint((att.X),(att.Y))))



nome.RunMethod("CenterRotate2:::",Array(att.Obj,pnlMain,DeltaAngle))


Rotated=True
Else If state= grLU.STATE_End Then
Return
RotRadians=nome.RunMethod("getAngle:",Array(img)).AsNumber
RotAngle=RotRadians*(180/cPI)
nome.RunMethod("Rotate::", Array(pnlMain,RotRadians))
nome.RunMethod("Rotate::", Array(img,RotRadians * (-1)))

End If
End Sub

Private Sub grImg_pan(state As Int, att As Pan_Attributes)
If state=grImg.STATE_Begin Then
setResizerVisible(False)
'curx=att.X'-zeroPointX
'cury=att.Y'-ZeroPointY

curx=(att.X*Cos(RotRadians))-(att.Y*Sin(RotRadians))
cury=(att.X*Sin(RotRadians))+(att.Y*Cos(RotRadians))

LastLocation=OBJC.PointToCGPoint(OBJC.GetCenter(pnlMain))
''
x1=att.X
y1=att.Y
''

Else If state=grImg.STATE_Changed Then


'pnlMain.Left=pnlMain.Left+att.X-curx
'pnlMain.Top=pnlMain.Top+att.Y-cury
Dim dx As Float=(att.X*Cos(RotRadians))-(att.Y*Sin(RotRadians))
Dim dy As Float=(att.X*Sin(RotRadians))+(att.Y*Cos(RotRadians))
Dim lx As Float=(pnlMain.Left*Sin(RotRadians))+(pnlMain.Top*Cos(RotRadians))
Dim ly As Float=(pnlMain.Left*Sin(RotRadians))+(pnlMain.Top*Cos(RotRadians))


''
nome.RunMethod("movepan:::",Array(att.Obj,pnlMain,LastLocation))
Return
''


'pnlMain.Left=lx+dx-curx
'pnlMain.Top=ly+dy-cury


pnlMain.Left=pnlMain.Left+dx-curx
pnlMain.Top=pnlMain.Top+dy-cury

'pnlMain.Left=pnlMain.Left+att.X-curx
'pnlMain.Top=pnlMain.Top+att.Y-cury
Else If state=grImg.STATE_End Then
setResizerVisible(True)
SaveAttributes
'mPhotos.SaveAttributes(getAttributes)
End If

End Sub

Private Sub grImg_pinch(state As Int, att As Pinch_Attributes)


If state=grImg.STATE_Begin Then
startWidth=img.width
StartHeight=img.height

Else If state=grImg.STATE_Changed Then



Dim width , height As Float
Dim wDiff, hDiff As Float

width=img.width*att.Scale
height=img.height*att.Scale

If width<50dip Then Return
If height<50dip Then Return

'pnlMain.Left=pnlMain.Left-((startWidth*att.Scale)-startWidth)
'pnlMain.Top=pnlMain.Top-((StartHeight*att.Scale)-StartHeight)
Dim p As Point=OBJC.GetCenter(pnlMain)
Resize(width,height)
OBJC.SetCenter(pnlMain,p)
Dim no As NativeObject=att.Obj
no.RunMethod("setScale:",Array(1))


'Return

''
'mscale=att.Scale
'MakeTransform(0,0)
Return
''

'Dim width , height As Float
width=startWidth*att.Scale
height=StartHeight*att.Scale
nome.RunMethod("vScale::",Array(pnlMain,att.Scale))
'Dim no As NativeObject=att.Obj
no.RunMethod("setScale:",Array(1))
'Resize(width,height)


End If
End Sub

Private Sub grborder_pan(state As Int, att As Pan_Attributes)
grImg_pan(state,att)
End Sub

Private Sub grBorder_pinch(state As Int, att As Pinch_Attributes)
grImg_pinch(state,att)
End Sub

Private Sub grImg_rotation(state As Int, att As Rotation_Attributes)
If state= grImg.STATE_Changed Then



Dim rot As Float=0-(LastRotation-att.Rotation)
''
'RotRadians=rot
'MakeTransform(att.x,att.Y)
'Return
''
nome.RunMethod("Rotate::", Array(pnlMain,rot))
LastRotation=att.Rotation
RotRadians=nome.RunMethod("getAngle:",Array(pnlMain)).AsNumber
RotAngle=RotRadians*(180/cPI)
Else If state=grImg.STATE_End Then
LastRotation=0
Return
End If
End Sub


Private Sub grMain_pan(state As Int, att As Pan_Attributes)
grImg_pan(state,att)
End Sub

Public Sub setResizerVisible (visible As Boolean)
If visible Then
pnlBorder.alpha=0: CornerRD.Alpha=0: CornerLU.Alpha=0
pnlBorder.SetBorder(BorderSize,BorderColor,0)
CornerRD.visible=True
CornerRU.visible=True
CornerLU.visible=True
CornerLD.visible=True
pnlBorder.SetAlphaAnimated(200,1)
CornerRD.SetAlphaAnimated(200,1)
CornerLU.SetAlphaAnimated(200,1)
CornerRU.SetAlphaAnimated(200,1)
CornerLD.SetAlphaAnimated(200,1)
img.BringToFront
Else
'pnlBorder.Visible=False
pnlBorder.SetBorder(BorderSize,Colors.Transparent,0)
CornerRD.visible=False
CornerRU.visible=False
CornerLU.visible=False
CornerLD.visible=False
pnlBorder.BringToFront
End If

mResizerVisible=visible
End Sub
Public Sub getResizerVisible As Boolean
Return mResizerVisible
End Sub


Private Sub pnlBorder_click
If getResizerVisible=False Then
setResizerVisible(True)
Else
setResizerVisible(False)
End If

End Sub

Private Sub img_Click
	
End Sub

Private Sub MakeTransform(x As Float, y As Float)
nome.RunMethod("updateTransformWithOffset::::::",Array(nome.MakePoint(x,y),pnlMain,mscale,RotRadians,x1,y1))
End Sub


Public Sub SaveAttributes As IMGResizerAttributes
If mName="" Then
mAttributes.Bitmap=ImgBytes
'mAttributes.Bitmap=img.Bitmap
Else
mAttributes.StikerName=mName
End If
'''????????????
mAttributes.RotationAngle=RotRadians
mAttributes.Width=img.Width
mAttributes.Height=img.Height'''????????????
mAttributes.X=OBJC.GetCenter(pnlMain).X
mAttributes.Y=OBJC.GetCenter(pnlMain).Y
'mAttributes=IR
Return mAttributes
End Sub

Public Sub LoadIRAttributes(Attributes As IMGResizerAttributes, ParentView As Panel)




ParentView.AddView(getAsView,0,0,getAsView.Width,getAsView.Height)

If Attributes.StikerName=Null Or Attributes.StikerName="null" Then 
	If Attributes.Bitmap Is Bitmap Then
	setBitmap(Attributes.Bitmap)
	Else If Attributes.Bitmap Is Byte Then
	Dim b As Bitmap
	'Dim input As InputStream
	'Dim imgBytes() As Byte=Attributes.Bitmap
	'input.InitializeFromBytesArray(imgBytes,0,imgBytes.Length)
	'b.Initialize2(input)
	Dim no As NativeObject
	'Dim input As InputStream
	'Dim bbb() As Byte=Attributes.Bitmap
	'input.InitializeFromBytesArray(Attributes.Bitmap,0,bbb.Length)
	'b.Initialize2(input)
	b=no.Initialize("UIImage").RunMethod("imageWithData:",Array(nome.ArrayToNSData(Attributes.Bitmap)))
	setBitmap(b)
	'bbb=Null
	'input=Null
	End If
	
Else
setImage(Attributes.StikerName)
End If

Dim p As Point
p.X=Attributes.X : p.Y=Attributes.Y
Rotate(Attributes.RotationAngle)

'IMGResizer.Image=Attributes.StikerName
OBJC.SetCenter(getAsView,p)

setAttributes(Attributes)
End Sub

Public Sub getOnlyViewMode As Boolean
Return True
End Sub
Public Sub setOnlyViewMode(YesNo As Boolean)
getAsView.UserInteractionEnabled=False
setResizerVisible(False)
End Sub

Private Sub CornerLD_click
RemoveFromParent
'mPhotos.CurTXTIMGAttributes.RemoveAt(mPhotos.CurTXTIMGAttributes.IndexOf(mAttributes))
'mPhotos.lstResizers.RemoveAt(mPhotos.lstResizers.IndexOf(Me))

End Sub

Private Sub CornerLU_click
pnlMain.BringToFront
'mPhotos.ChangeOrder(mAttributes)
End Sub

Public Sub RemoveFromParent
pnlMain.RemoveViewFromParent

End Sub

Public Sub Rotate(Radians As Float)
nome.RunMethod("Rotate::",Array(pnlMain,Radians))
RotRadians=Radians
End Sub

Public Sub getAttributes As IMGResizerAttributes
SaveAttributes
Return mAttributes
End Sub
Public Sub setAttributes (Attribute As IMGResizerAttributes)
mAttributes=Attribute
End Sub


#If OBJC



-(B4IRect*)CenterRotate: (UIView*)v :(CGPoint)nowPoint
{
    CGPoint point1 = v.center;
   // CGFloat dx = point1.x - x;
    //CGFloat dy = point1.y - y;
    //CGFloat distanceBetweenPoints =sqrt(dx*dx + dy*dy);
	
	CGFloat angle = angleBetweenLinesInDegrees2(point1, point1, point1, nowPoint);
    v.transform = CGAffineTransformMakeRotation(angle *  M_PI / 180);
	//v.transform = CGAffineTransformRotate(v.transform,angle) ;
	CGRect transformedBounds = CGRectApplyAffineTransform(v.bounds, v.transform);
	B4IRect * r;
	r=[B4IRect new];
	[r Initialize :(float)(transformedBounds.origin.x) :(float)(transformedBounds.origin.y) :(float)(transformedBounds.size.width) :(float)(transformedBounds.size.height)];
	//r.left=transformedBounds.origin.x;
	//r.top=transformedBounds.origin.y;
	//r.right=transformedBounds.size.width;
	//r.bottom=transformedBounds.size.height;
	return r;
}

-(void)CenterRotate2: (UIGestureRecognizer*)recognizer :(UIView*)view :(float)delta
{
float ang = atan2([recognizer locationInView:view.superview].y - view.center.y,
                          [recognizer locationInView:view.superview].x - view.center.x);

        float angleDiff = delta- ang;
        view.transform = CGAffineTransformMakeRotation(-angleDiff);
}


-(void)Rotate: (UIView*)v :(float)ang
{
   
    v.transform = CGAffineTransformRotate(v.transform,ang) ;
//*  M_PI / 180)
}

CGFloat angleBetweenLinesInDegrees2(CGPoint beginLineA,
                                   CGPoint endLineA,
                                   CGPoint beginLineB,
                                   CGPoint endLineB)
{
    CGFloat a = endLineA.x - beginLineA.x;
    CGFloat b = endLineA.y - beginLineA.y;
    CGFloat c = endLineB.x - beginLineB.x;
    CGFloat d = endLineB.y - beginLineB.y;
 
    CGFloat atanA = atan2(a, b);
    CGFloat atanB = atan2(c, d);
 
    // convert radiants to degrees
    return (atanA - atanB) * 180 / M_PI;
}



-(float) getAngle: (UIView *)v
{
CGFloat angle = atan2f(v.transform.b, v.transform.a);
//angle = angle * (180 / M_PI);
return angle;
}


-(void) vScale: (UIView*)view :(float)scale
{
 [view setTransform:CGAffineTransformScale(view.transform, scale, scale)];

}

- (void) updateTransformWithOffset: (CGPoint) translation :(UIView*)view :(float)scale :(float)theta :(float)tx :(float)ty
{
    // Create a blended transform representing translation,
    // rotation, and scaling
    view.transform = CGAffineTransformMakeTranslation(
        translation.x + tx, translation.y + ty);
    view.transform = CGAffineTransformRotate(view.transform, theta);
    view.transform = CGAffineTransformScale(view.transform, scale, scale);
	
}

-(void)movepan:(UIPanGestureRecognizer *)panGestureRecognizer :(UIView*)view :(CGPoint)lastLocation
{
 
    CGPoint translation = [panGestureRecognizer translationInView:view.superview];
    view.center = CGPointMake(lastLocation.x + translation.x,
                              lastLocation.y + translation.y);

}

-(CGPoint)ResizeView :(UIGestureRecognizer*)recognizer :(UIView*)view :(CGPoint)prevPoint
{
CGPoint point = [recognizer locationInView:view];
float wChange = 0.0, hChange = 0.0;

            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)view.bounds.size.width);

            hChange = wRatioChange * view.bounds.size.height;

           // if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
           // {
           //     self.prevPoint = [recognizer locationOfTouch:0 inView:self];
           //     return;
           // }

            view.bounds = CGRectMake(view.bounds.origin.x, view.bounds.origin.y,
                                     view.bounds.size.width + (wChange),
                                     view.bounds.size.height + (hChange));
		    CGPoint p=[recognizer locationOfTouch:0 inView:self];
			return p;
}

-(float)aaa: (UIView*)view
{

float X = sqrt(view.transform.a*view.transform.a + view.transform.c*view.transform.c);
return X;
}


-(NSData *)compressImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 800.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.7;//50 percent compression

    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }

    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();

	return imageData;
    //return [UIImage imageWithData:imageData];
}


#end if

