B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=4.3
@EndOfDesignText@
'Code module
#IgnoreWarnings:19,2,12,11
Private Sub Process_Globals
	Private nome As NativeObject
End Sub

Sub ResizeImage (Image As Bitmap, Width As Int, Height As Int) As Bitmap
	Dim PhotoCanvas As Canvas
	Dim PhotoPanel As Panel
	Dim PhotoView As ImageView
	Dim NewImage As Bitmap
   
	PhotoPanel.Initialize("")
	PhotoPanel.Width = Width / 2
	PhotoPanel.Height = Height / 2
   
	PhotoView.Initialize("")
	PhotoView.Bitmap = Image
   
	PhotoPanel.AddView(PhotoView,0,0,Width / 2,Height / 2)

	PhotoCanvas.Initialize(PhotoPanel)
	NewImage = PhotoCanvas.CreateBitmap
   
	Return NewImage
End Sub

Sub GetColorDrawable(View As View,Color As Int,Radius As Float)
	View.SetBorder(0,0,Radius)
	View.Color	=	Color
End Sub

'format is JPEG,PNG
Sub GetByteFromBitmap(Bitmap1 As Bitmap, Quality As Int,Format As String) As Byte()
	Dim out As OutputStream
	Dim data() As Byte
	out.InitializeToBytesArray(1)
	Bitmap1.WriteToStream(out,Quality,"JPEG")
	data = out.ToBytesArray
	out.Close
	Return data
End Sub

Sub BmpColor(img As ImageView, color As Int, color2 As Int)
	Dim NaObj As NativeObject = Me
	NaObj.RunMethod("BmpColor:::",Array(img,NaObj.ColorToUIColor(color),NaObj.ColorToUIColor(color2)))
	#If OBJC
	- (void)BmpColor: (UIImageView*) theImageView :(UIColor*) Color : (UIColor*)Color2 {
	theImageView.image = [theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	theImageView.backgroundColor =  Color2;
	[theImageView setTintColor:Color];
	}
	#end if
End Sub

Sub ReplaceColor(Bitmap As Bitmap,Color As Int) As Bitmap
	
	Dim No As NativeObject = Me
	Return No.RunMethod("TintImage::",Array (Bitmap,No.ColorToUIColor(Color)))
	
	#if OBJC
	-(UIImage *) TintImage: (UIImage *) image : (UIColor *) tintcolor{

		UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
		[tintcolor set];
		[newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		return newImage;

	}
	#End If

End Sub

'format is JPEG,PNG
'quality is between 0 and 100 , 100 is high quality
Sub SaveBitmap(Bitmap1 As Bitmap,Dir As String,Filename As String,Format As String,Quality As Int)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap1
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,Quality,Format)
	out.Close
End Sub

Sub CreateScaledBitmap (Image As Bitmap, Width As Int, Height As Int) As Bitmap
	Dim PhotoCanvas As Canvas
	Dim PhotoPanel As Panel
	Dim PhotoView As ImageView
	Dim NewImage As Bitmap

	PhotoPanel.Initialize("")
	PhotoPanel.Width = Width / 2
	PhotoPanel.Height = Height / 2

	PhotoView.Initialize("")
	PhotoView.Bitmap = Image
	PhotoPanel.AddView(PhotoView,0,0,Width / 2,Height / 2)

	PhotoCanvas.Initialize(PhotoPanel)
	NewImage = PhotoCanvas.CreateBitmap

	Return NewImage
End Sub

Sub RoundBitmap(Input As Bitmap,Corner As Int) As Bitmap
	
	Dim xui As XUI
	Dim BorderColor As Int = xui.Color_Black
	Dim BorderWidth As Int = 0
	Dim c As B4XCanvas
	Dim xview As B4XView = xui.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, Input.Width, Input.Height)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeRoundedRect(c.TargetRect, Corner)
	c.ClipPath(path)
	c.DrawRect(c.TargetRect, BorderColor, True, BorderWidth) 'border
	c.RemoveClip
	Dim r As B4XRect
	r.Initialize(BorderWidth, BorderWidth, c.TargetRect.Width - BorderWidth, c.TargetRect.Height - BorderWidth)
	path.InitializeRoundedRect(r, Corner)
	c.ClipPath(path)
	c.DrawBitmap(Input, r)
	c.RemoveClip
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	Return res
	
End Sub

Sub RotateImageByDegrees(original As Bitmap, degree As Float) As Bitmap
	Return original.Rotate(degree)
End Sub

Sub RotateImageByRadians(original As Bitmap, radians As Float) As Bitmap
	original= nome.RunMethod("imageRotatedByRadians::", Array(original,radians))
	Return original
End Sub

#If OBJC
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};
- (UIImage *)imageRotatedByRadians:(UIImage *)bmp:(CGFloat)radians
{
return [self imageRotatedByDegrees:bmp:RadiansToDegrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(UIImage *)bmp:(CGFloat)degrees
{ 
// calculate the size of the rotated view's containing box for our drawing space
UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,bmp.size.width, bmp.size.height)];
CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
rotatedViewBox.transform = t;
CGSize rotatedSize = rotatedViewBox.frame.size;

// Create the bitmap context
UIGraphicsBeginImageContext(rotatedSize);
CGContextRef bitmap = UIGraphicsGetCurrentContext();

// Move the origin to the middle of the image so we will rotate and scale around the center.
CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

// Rotate the image context
CGContextRotateCTM(bitmap, DegreesToRadians(degrees));

// Now, draw the rotated/scaled image into the context
CGContextScaleCTM(bitmap, 1.0, -1.0);
CGContextDrawImage(bitmap, CGRectMake(-bmp.size.width / 2, -bmp.size.height / 2, bmp.size.width, bmp.size.height), bmp.CGImage);

UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return newImage;
}
#End If

Sub FillImage(bmp As B4XBitmap, ImageView As B4XView) As Bitmap
	Dim bmpRatio As Float = bmp.Width / bmp.Height
	Dim viewRatio As Float = ImageView.Width / ImageView.Height
	If viewRatio > bmpRatio Then
		Dim NewHeight As Int = bmp.Width / viewRatio
		bmp = bmp.Crop(0, bmp.Height / 2 - NewHeight / 2, bmp.Width, NewHeight)
	Else if viewRatio < bmpRatio Then
		Dim NewWidth As Int = bmp.Height * viewRatio
		bmp = bmp.Crop(bmp.Width / 2 - NewWidth / 2, 0, NewWidth, bmp.Height)
	End If
	Return (bmp.Resize(ImageView.Width, ImageView.Height, True))
End Sub

Sub GetPixelColor(Bitmap1 As Bitmap, x As Int, y As Int) As Int
	Dim NativeMe As NativeObject = Me
	Dim UIColor As Object = NativeMe.RunMethod("GetPixelColor:::", Array (Bitmap1,x,y))
	Return NativeMe.UIColorToColor(UIColor)
End Sub

Sub SetPixelColor(aBitmap As Bitmap,X As Int,Y As Int, Color As Int) As Bitmap
	Dim Scale As Float = GetDeviceLayoutValues.NonnormalizedScale
	Dim img As ImageView
	img.Initialize("")
	img.Width = aBitmap.Width / Scale
	img.Height = aBitmap.Height/ Scale
	img.Bitmap = aBitmap
  
	Dim cvs As Canvas
	cvs.Initialize(img)
  
	Dim PointRect As Rect
	PointRect.Initialize(X/Scale,Y/Scale,(X+1)/Scale,(Y+1)/Scale)
  
	cvs.DrawRect(PointRect,Color,True,1/Scale)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Refresh
	Return res
End Sub

#If OBJC

- (UIColor *)GetPixelColor:(UIImage *)bitmap :(int)x :(int)y {
 
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(bitmap.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
 
    //int pixelInfo = ((bitmap.size.width  * y) + x ) * 4;   //<-- Not always true!!
    
    // Add these 2 lines instead
    int stride = CGImageGetBytesPerRow(bitmap.CGImage); 
    int pixelInfo = (stride  * y) + x*4 ;

    UInt8 red = data[pixelInfo];
    UInt8 green = data[(pixelInfo + 1)];
    UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);

    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
}
#End If

Private Sub fixOrientation_image(Bitmap1 As Bitmap) As Bitmap
	Dim no As NativeObject = Me
	Return no.RunMethod("fixOrientation:", Array(Bitmap1))
End Sub
#if OBJC
- (UIImage *)fixOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#end if

Sub Hex2RGB(Hex As String) As Int
	Hex = Hex.Replace("###","#").Replace("##","#")
	If Hex.SubString2(0,1) <> "#" Then Hex = "#" & Hex
	Dim m As Map
	m.Initialize
	Dim r,g,b As Int
	' #E3E2E1
	'Log(hex.SubString2(1,3))
	r = Bit.ParseInt(Hex.SubString2(1,3), 16)
	g = Bit.ParseInt(Hex.SubString2(3,5), 16)
	b = Bit.ParseInt(Hex.SubString2(5,7), 16)
	m.Put("r",r)
	m.put("g",g)
	m.Put("b", b)
	Dim t As Int
	t = Colors.RGB(r,g,b)
	Return t
End Sub

Sub GetRGB(Color As Int) As Int()
	Private res(4) As Int
	res(0) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff000000), 24)
	res(1) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff0000), 16)
	res(2) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff00), 8)
	Return res
End Sub

Sub GetBitmapFromColor(Page As Page,Color As Int) As Bitmap
	
	Dim lb As Label
	lb.Initialize("")
'	lb.Visible	=	False
	Page.RootPanel.AddView(lb,-2000dip,0,100dip,100dip)
	lb.Color	=	Color
	
	Dim ca As Canvas
	ca.Initialize(lb)
	ca.Refresh
	
	Dim bt As Bitmap
	bt	=	ca.CreateBitmap
	lb.RemoveViewFromParent
	
	Return bt
	
End Sub

Sub Bitmap2File(Bitmap2 As Bitmap,Dir As String,Filename As String,Format As String,Quality As Int)
	
	Dim out As OutputStream
	out = File.OpenOutput(Dir,Filename, False)
	Bitmap2.WriteToStream(out, Quality, Format.ToUpperCase)
	out.Close
	
End Sub

Sub FillImageToView(bmp As B4XBitmap, ImageView As B4XView)
	Dim bmpRatio As Float = bmp.Width / bmp.Height
	Dim viewRatio As Float = ImageView.Width / ImageView.Height
	If viewRatio > bmpRatio Then
		Dim NewHeight As Int = bmp.Width / viewRatio
		bmp = bmp.Crop(0, bmp.Height / 2 - NewHeight / 2, bmp.Width, NewHeight)
	Else if viewRatio < bmpRatio Then
		Dim NewWidth As Int = bmp.Height * viewRatio
		bmp = bmp.Crop(bmp.Width / 2 - NewWidth / 2, 0, NewWidth, bmp.Height)
	End If
	ImageView.SetBitmap(bmp.Resize(ImageView.Width, ImageView.Height, True))
End Sub

Sub CompressToBitmap(Dir As String,Filename As String,Quality As Int,Width As Int,Height As Int) As Bitmap
	
	Dim origBitmap As Bitmap = LoadBitmapResize(Dir,Filename,Width,Height,True)
	Dim out As OutputStream = File.OpenOutput(File.DirTemp, "1.jpg", False)
	origBitmap.WriteToStream(out, Quality, "JPEG")
	out.Close
	
	Return LoadBitmap(File.DirTemp, "1.jpg")
	
End Sub

Sub LoadBitmapWithScale(Dir As String, FileName As String, Scale As Float) As Bitmap
	Dim bytes() As Byte = Bit.InputStreamToBytes(File.OpenInput(Dir, FileName))
	Dim no As NativeObject
	Return no.Initialize("UIImage").RunMethod("imageWithData:scale:", Array(no.ArrayToNSData(bytes), Scale))
End Sub

Sub SetBitmapDensity(Bitmap As Bitmap) As Bitmap
	
	SaveBitmap(Bitmap,File.DirTemp,"temp.png","PNG",100)
	
	Dim bt As Bitmap
	bt	=	LoadBitmapWithScale(File.DirTemp,"temp.png",1.5)
	
	File.Delete(File.DirTemp,"temp.png")
	
	Return bt
	
End Sub

'get new height according of bitmap width
Public Sub GetNewHeight(Bitmap2 As Bitmap,w As Int) As Int
	Return Bitmap2.Height*w/Bitmap2.Width
End Sub

'round bitmap with buildin function (without imageview border)
Public Sub RoundedImageBuildIn(radius As Float,Image As Bitmap) As Bitmap
	Dim NativeMe As NativeObject = Me
	Return NativeMe.RunMethod("makeRoundedImage::", Array (Image,radius))
	#If OBJC
	- (UIImage *)makeRoundedImage:(UIImage *)image :(CGFloat)radious {

	if(radious == 0.0f)
	    return image;
	  
	if( image != nil) {

	    CGFloat imageWidth = image.size.width;
	    CGFloat imageHeight = image.size.height;

	    CGRect rect = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
	    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	    const CGFloat scale = window.screen.scale;
	    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);

	    CGContextRef context = UIGraphicsGetCurrentContext();

	    CGContextBeginPath(context);
	    CGContextSaveGState(context);
	    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	    CGContextScaleCTM (context, radious, radious);

	    CGFloat rectWidth = CGRectGetWidth (rect)/radious;
	    CGFloat rectHeight = CGRectGetHeight (rect)/radious;

	    CGContextMoveToPoint(context, rectWidth, rectHeight/2.0f);
	    CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2.0f, rectHeight, radious);
	    CGContextAddArcToPoint(context, 0.0f, rectHeight, 0.0f, rectHeight/2.0f, radious);
	    CGContextAddArcToPoint(context, 0.0f, 0.0f, rectWidth/2.0f, 0.0f, radious);
	    CGContextAddArcToPoint(context, rectWidth, 0.0f, rectWidth, rectHeight/2.0f, radious);
	    CGContextRestoreGState(context);
	    CGContextClosePath(context);
	    CGContextClip(context);

	    [image drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];

	    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	    UIGraphicsEndImageContext();

	    return newImage;
	}

	return nil;
	}

	- (UIImage *)CircleCrop:(UIImage *)image :(UIImageView *)imageView :(CGFloat) radius:(CGFloat) q
	{
	 UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, q);
	[[UIBezierPath bezierPathWithRoundedRect:imageView.bounds 
	                            cornerRadius:radius] addClip];
	[image drawInRect:imageView.bounds];

	UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();

	// Lets forget about that we were drawing
	UIGraphicsEndImageContext();
	return image2;
	}

	#End if
End Sub

private Sub CircleCrop (Bitmap As Bitmap,img As ImageView,Radius As Float,Quality As Float) As Bitmap
	Dim NativeMe As NativeObject = Me
	Return NativeMe.RunMethod("CircleCrop::::", Array (Bitmap,img,Radius,Quality))
End Sub

Public Sub Blur (bmp As B4XBitmap) As B4XBitmap
	Dim n As Long = DateTime.Now
	Dim bc As BitmapCreator
	Dim ReduceScale As Int = 2
	bc.Initialize(bmp.Width / ReduceScale / bmp.Scale, bmp.Height / ReduceScale / bmp.Scale)
	bc.CopyPixelsFromBitmap(bmp)
	Dim count As Int = 3
	Dim clrs(3) As ARGBColor
	Dim temp As ARGBColor
	Dim m As Int
	For steps = 1 To count
		For y = 0 To bc.mHeight - 1
			For x = 0 To 2
				bc.GetARGB(x, y, clrs(x))
			Next
			SetAvg(bc, 1, y, clrs, temp)
			m = 0
			For x = 2 To bc.mWidth - 2
				bc.GetARGB(x + 1, y, clrs(m))
				m = (m + 1) Mod clrs.Length
				SetAvg(bc, x, y, clrs, temp)
			Next
		Next
		For x = 0 To bc.mWidth - 1
			For y = 0 To 2
				bc.GetARGB(x, y, clrs(y))
			Next
			SetAvg(bc, x, 1, clrs, temp)
			m = 0
			For y = 2 To bc.mHeight - 2
				bc.GetARGB(x, y + 1, clrs(m))
				m = (m + 1) Mod clrs.Length
				SetAvg(bc, x, y, clrs, temp)
			Next
		Next
	Next
	Log(DateTime.Now - n)
	Return bc.Bitmap
End Sub

Private Sub SetAvg(bc As BitmapCreator, x As Int, y As Int, clrs() As ARGBColor, temp As ARGBColor)
	temp.Initialize
	For Each c As ARGBColor In clrs
		temp.r = temp.r + c.r
		temp.g = temp.g + c.g
		temp.b = temp.b + c.b
	Next
	temp.a = 255
	temp.r = temp.r / clrs.Length
	temp.g = temp.g / clrs.Length
	temp.b = temp.b / clrs.Length
	bc.SetARGB(x, y, temp)
End Sub