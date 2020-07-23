B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.01
@EndOfDesignText@
#DesignerProperty: Key: maptype, DisplayName: MapType, FieldType: String, DefaultValue: NORMAL, LIST: NORMAL|HYBRID|SATELLITE|TERRAIN
#DesignerProperty: Key: locationenable, DisplayName: My Location Enabled, FieldType: Boolean, DefaultValue: True, Description:Show user location button on map
#DesignerProperty: Key: traffic, DisplayName: Traffic Enabled, FieldType: Boolean, DefaultValue: False, Description:Enable traffic state on map
#DesignerProperty: Key: showinfo, DisplayName: Show infoWindow on marker, FieldType: Boolean, DefaultValue: False, Description:Set true for show info windows on click marker
#DesignerProperty: Key: api, DisplayName: Api Key, FieldType: String, DefaultValue: , Description:Enter googlemap api for show map
#Event: Ready
#Event: CameraChange(Position As CameraPosition)
#Event: Click(Point As LatLng)
#Event: LongClick
#Event: MarkerClick(SelectedMarker As Marker)
#Event: MarkerInfoWindow(Marker As Object) As Object
#Event: InfoWindowClick(Marker As Marker)
#IgnoreWarnings: 17,2,12

Sub Class_Globals
	Private no As NativeObject
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As WeakRef
	Private Const DefaultColorConstant As Int = -984833 'ignore
	Private googlemap As GoogleMap
	Private Properties As Map
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName	= EventName
	mCallBack	= Callback
	no			= Me
End Sub

Public Sub DesignerCreateView (Base As Panel, Lbl As Label, Props As Map)

	mBase.Value = Base
	Properties	= Props
	
	Dim api_key As String
	If Props.Get("api") <> "" Then
		api_key = Props.Get("api")
	Else
		If File.Exists(File.DirAssets,"googlemapapi.txt") Then
			api_key = File.ReadString(File.DirAssets,"googlemapapi.txt")	
		Else
			Log("Please add file googlemapapi.txt to DirAsset (contain GoogleMapApi")
			Return
		End If
	End If
	
	googlemap.Initialize("googlemap",api_key)
	Base.AddView(googlemap, 0, 0, Base.Width, Base.Height)
	
	If Props.Get("maptype") = "NORMAL" Then
		googlemap.MapType = googlemap.MAP_TYPE_NORMAL
		
	Else If Props.Get("maptype") = "HYBRID" Then
		googlemap.MapType = googlemap.MAP_TYPE_HYBRID
	
	Else If Props.Get("maptype") = "SATELLITE" Then
		googlemap.MapType = googlemap.MAP_TYPE_SATELLITE
	
	Else If Props.Get("maptype") = "TERRAIN" Then
		googlemap.MapType = googlemap.MAP_TYPE_TERRAIN
		
	End If
	
	If Props.Get("locationenable") = True Then
		googlemap.GetUiSettings.MyLocationButtonEnabled	=	True
		googlemap.MyLocationEnabled = True
	End If
	
	If Props.Get("traffic") = True Then
		googlemap.TrafficEnabled = True
	End If
	
	CallSubDelayed(mCallBack,mEventName & "_ready")
	
End Sub

Private Sub googlemap_CameraChange (Position As CameraPosition)
	
	If SubExists(mCallBack,mEventName & "_camerachange",1) Then
		CallSubDelayed2(mCallBack,mEventName & "_camerachange",Position)
	End If
	
End Sub

Private Sub googlemap_Click (Point As LatLng)
	
	If SubExists(mCallBack,mEventName & "_click",1) Then
		CallSubDelayed2(mCallBack,mEventName & "_click",Point)
	End If
	
End Sub

Private Sub googlemap_LongClick
	
	If SubExists(mCallBack,mEventName & "_longclick",1) Then
		CallSubDelayed(mCallBack,mEventName & "_longclick")
	End If
	
End Sub

Private Sub googlemap_MarkerClick (SelectedMarker As Marker) As Boolean 'Return True to consume the click
	
	If SubExists(mCallBack,mEventName & "_markerclick",1) Then
		CallSubDelayed2(mCallBack,mEventName & "_markerclick",SelectedMarker)
	End If
	
	Return Properties.Get("showinfo")
	
End Sub

Private Sub googlemap_MarkerInfoWindow(OMarker As Object) As Object
	
	If SubExists(mCallBack,mEventName & "_markerinfowindow",1) Then
		Dim res As Object
		res	=	CallSub2(mCallBack,mEventName & "_markerinfowindow",OMarker)
		If res <> Null Then
			Return res
		End If
	End If
	
End Sub

Private Sub googlemap_InfoWindowClick (SelectedMarker As Marker)
	If SubExists(mCallBack,mEventName & "_infowindowclick",1) Then
		CallSubDelayed2(mCallBack,mEventName & "_infowindowclick",SelectedMarker)
	End If
End Sub

Public Sub ClearMap
	googlemap.Clear
End Sub

Public Sub getGetUiSettings As MapUiSettings
	Return googlemap.GetUiSettings
End Sub

Public Sub GetMap As GoogleMap
	Return googlemap
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
End Sub

Public Sub GetBase As Panel
	Return mBase.Value
End Sub

Public Sub ZoomPosition(Latitude As Double,Longitude As Double,Zoom As Float,WithAnimation As Boolean)
	
	Dim cp As CameraPosition
	cp.Initialize2(Latitude,Longitude,Zoom,100,45)
	
	If WithAnimation Then
		googlemap.AnimateCamera(cp)
	Else
		googlemap.MoveCamera(cp)
	End If
	
End Sub

Sub CheckLocation As Boolean

	Dim location1 As LocationManager
	location1.Initialize("")
	
	Dim d1 As Boolean
	d1 = location1.LocationServicesEnabled
	Return d1
	
End Sub

Public Sub Distance(FirstLatLon As LatLng,SecondLatLon As LatLng) As Double
	
	Dim f_l,s_l As Location
	f_l.Initialize2(FirstLatLon.Latitude,FirstLatLon.Longitude)
	s_l.Initialize2(SecondLatLon.Latitude,SecondLatLon.Longitude)
	
	Return f_l.DistanceTo(s_l)
	
End Sub

'add JsonFileName in DirAsset
Public Sub ChangeMapTheme(JsonFileName As String)
	Dim ngm As NativeObject = GetMap
	Dim style As Object = no.RunMethod("createMapStyle:", Array(File.ReadString(File.DirAssets,JsonFileName)))
	ngm.SetField("mapStyle", style)
End Sub

Sub ZoomToMarkerBounds(Points As List,Padding As Int)
	
	Dim bounds As Object = no.RunMethod("createBoundsIncluding:", Array(Points))
	Dim update As NativeObject
	update = update.Initialize("GMSCameraUpdate").RunMethod("fitBounds:withPadding:", Array(bounds, Padding))
	Dim gmapNo As NativeObject = GetMap
	gmapNo.RunMethod("animateWithCameraUpdate:", Array(update))
	
End Sub

Public Sub AddPolygon (Points As List, FillColor As Int, StrokeColor As Int,StrokeWidth As Int)
	Dim path As NativeObject = no.RunMethod("createPath:", Array(Points))
	Dim polygon As NativeObject
	polygon = polygon.Initialize("GMSPolygon").RunMethod("polygonWithPath:", Array(path))
	polygon.SetField("map", GetMap)
	polygon.SetField("strokeWidth", StrokeWidth)
	polygon.SetField("fillColor", polygon.ColorToUIColor(FillColor))
	polygon.SetField("strokeColor", polygon.ColorToUIColor(StrokeColor))
End Sub

public Sub CreateBounds (NorthEast As LatLng, SouthWest As LatLng) As Object
	Return no.RunMethod("createBounds::", Array(NorthEast, SouthWest))
End Sub

public Sub AddGroundOverlay(Bounds As Object, Image As Bitmap)
	Dim overlay As NativeObject
	overlay = overlay.Initialize("GMSGroundOverlay").RunMethod( _
		"groundOverlayWithBounds:icon:", Array(Bounds, Image))
	overlay.SetField("map", GetMap)
End Sub

Public Sub SetSelectedMarker(Marker As Marker)
	Dim ngm As NativeObject = GetMap
	ngm.SetField("selectedMarker", Marker)
End Sub

Public Sub UnselectMarkers
	Dim ngm As NativeObject = GetMap
	ngm.SetField("selectedMarker", Null)
	
End Sub

Public Sub SetMarkerRotation(Marker As Marker, Rotation As Double)
	Dim m As NativeObject = Marker
	m.SetField("rotation", Rotation)
End Sub

'Sets the icon anchor. Both values should be between 0 to 1.
Public Sub SetGroundAnchor(Marker As Marker, X As Double, Y As Double)
	Dim m As NativeObject = Marker
	m.RunMethod("setGroundAnchor:", Array(m.MakePoint(X, Y)))
End Sub

Public Sub GetProjection As NativeObject
	Dim ngm As NativeObject = GetMap
	Return ngm.GetField("projection")
End Sub

Public Sub GetVisibleBounds As NativeObject
	Dim Bounds As NativeObject
	Bounds = no.RunMethod("coordinateBoundsFromProjection:", Array(GetProjection))
	Return Bounds
End Sub

Public Sub BoundsContain(Bounds As NativeObject, LatLng As LatLng) As Boolean
	Return no.RunMethod("boundsContain::", Array(Bounds, LatLng)).AsBoolean
End Sub

'Adds a circle at the given point.
'Radius is measured in meters.
Public Sub AddCircle (Lat As Double, Lon As Double, Radius As Double, Color As Int,StrokeWidth As Int)
	Dim circle As NativeObject = no.RunMethod("createCircle:::", Array(Lat, Lon, Radius))
	circle.SetField("map", GetMap)
	circle.SetField("strokeWidth", StrokeWidth)
	circle.SetField("fillColor", circle.ColorToUIColor(Color))
	circle.SetField("strokeColor", circle.ColorToUIColor(Color))
End Sub

Sub MapsDecodePolyline(encoded As String,point As List)
     
	Dim index As Int
	Dim lat As Int
	Dim lng As Int
	Dim fLat As Float
	Dim fLng As Float
	Dim b As Int
	Dim shift As Int
	Dim result As Int
	Dim dlat As Int
	Dim dlng As Int
	index = 0 : lat = 0 : lng = 0
	Do While index < encoded.Length
		shift = 0 : result = 0
		Do While True
			b = Asc(encoded.SubString2(index, index + 1)) - 63 : index = index + 1
			result = Bit.Or(result, Bit.ShiftLeft(Bit.And(b, 0x1f), shift))
			shift = shift + 5
			If b < 0x20 Then Exit
		Loop
		
		If Bit.And(result, 1) = 1 Then
			dlat = Bit.Not(Bit.ShiftRight(result, 1))
		Else
			dlat = Bit.ShiftRight(result, 1)
		End If
		lat = lat + dlat
		shift = 0 : result = 0
		Do While True
			b = Asc(encoded.SubString2(index, index + 1)) - 63 : index = index + 1
			result = Bit.Or(result, Bit.ShiftLeft(Bit.And(b, 0x1f), shift))
			shift = shift + 5
			If b < 0x20 Then Exit
		Loop
		
		If Bit.And(result, 1) = 1 Then
			dlng = Bit.Not(Bit.ShiftRight(result, 1))
		Else
			dlng = Bit.ShiftRight(result, 1)
		End If
		lng = lng + dlng
		fLat = lat
		fLng = lng
		
		Dim loc As LatLng
		loc.Initialize(fLat / 100000,fLng / 100000)
		point.add(loc)
	Loop
	
End Sub

Sub Snapshot(Page1 As Page)
	
	Dim iv As ImageView
	iv.Initialize("")
	Page1.RootPanel.AddView(iv,-GetMap.Width,-GetMap.Height,GetMap.Width,GetMap.Height)
	
	Dim cvs As Canvas
	cvs.Initialize(iv)
	Dim dest As Rect
	dest.Initialize(0, 0, iv.Width, iv.Height)
	cvs.DrawView(iv, dest)
	cvs.Refresh
	
	CallSubDelayed2(Me,mEventName & "_getsnapshot",cvs.CreateBitmap)
	
End Sub

Public Sub SetInfoWindowAnchor(Marker As Marker, X As Double, Y As Double)
	Dim m As NativeObject = Marker
	m.RunMethod("setInfoWindowAnchor:", Array(m.MakePoint(X, Y)))
End Sub

Public Sub ScreenToCoordinate(X As Double, Y As Double) As LatLng
	Return no.RunMethod("screenToCoordinate:::", Array(GetProjection, X, Y))
End Sub

'Returns x, y
Public Sub CoordinateToScreen(ll As LatLng) As Double()
	Dim arr As NativeObject = no.RunMethod("coordinateToScreen::", Array(GetProjection, ll))
	Return Array As Double(arr.RunMethod("objectAtIndex:", Array(0)).AsNumber, _
		arr.RunMethod("objectAtIndex:", Array(1)).AsNumber)
End Sub

Sub SetMapMinAndMaxZoom(gMapView As GoogleMap,gMin As Float,gMax As Float)
	Dim no1 As NativeObject = gMapView
	no1.RunMethod("setMinZoom:maxZoom:", Array(gMin,gMax))
	#If OBJC
- (void) setMapMinAndMaxZoom:(GMSMapView *)gMapView :(float)gMin :(float)gMax {
   [gMapView setMinZoom:gMin maxZoom:gMax];
   }
#End If
End Sub

#If OBJC
#import "iGoogleMaps.h"
#import <GoogleMaps/GoogleMaps.h>
- (NSArray*) coordinateToScreen:(GMSProjection*)projection :(B4ILatLng*)ll {
	CGPoint p = [projection pointForCoordinate:CLLocationCoordinate2DMake(ll.Latitude, ll.Longitude)];
	return @[@(p.x), @(p.y)];
}
- (B4ILatLng*) screenToCoordinate:(GMSProjection*)projection :(double)x :(double)y {
	CLLocationCoordinate2D c = [projection coordinateForPoint:CGPointMake(x, y)];
	B4ILatLng* ll = [B4ILatLng new];
	[ll Initialize:c.latitude :c.longitude];
	return ll;
}
- (NSObject*) createMapStyle:(NSString*)json {
	return [GMSMapStyle styleWithJSONString:json error:nil];
}
- (NSObject*)createCircle:(double)lat :(double)lon :(double)radius {
	return [GMSCircle circleWithPosition:CLLocationCoordinate2DMake(lat, lon) radius:(CLLocationDistance)radius];
}
- (NSObject*)createBounds:(B4ILatLng*)ne :(B4ILatLng*)sw {
	return [[GMSCoordinateBounds alloc] 
		initWithCoordinate:CLLocationCoordinate2DMake(ne.Latitude, ne.Longitude)
		coordinate:CLLocationCoordinate2DMake(sw.Latitude, sw.Longitude)];
}
- (BOOL)boundsContain:(GMSCoordinateBounds*) bounds :(B4ILatLng*) ll {
	return [bounds containsCoordinate:CLLocationCoordinate2DMake(ll.Latitude, ll.Longitude)];
}
- (NSObject*)createBoundsIncluding:(NSArray*)points {
	GMSCoordinateBounds* bounds = [GMSCoordinateBounds new];
	for (B4ILatLng* ll in points) {
		 bounds = [bounds includingCoordinate:CLLocationCoordinate2DMake(ll.Latitude, ll.Longitude)];
	}
	return bounds;
}
- (NSObject*)createPath:(NSArray*)points {
	GMSMutablePath* p = [GMSMutablePath new];
	for (B4ILatLng* ll in points) {
		 [p addCoordinate:CLLocationCoordinate2DMake(ll.Latitude, ll.Longitude)];
	}
	return p;
}
- (NSObject*)coordinateBoundsFromProjection:(GMSProjection*) p {
	return [[GMSCoordinateBounds alloc]initWithRegion: [p visibleRegion]];
}
- (void)getLatLngFromBounds:(GMSCoordinateBounds*) bounds :(B4ILatLng*) northEast :(B4ILatLng*) southWest {
	[northEast Initialize:bounds.northEast.latitude :bounds.northEast.longitude];
	[southWest Initialize:bounds.southWest.latitude :bounds.southWest.longitude];
}
@end
@implementation B4IMapDelegate (override)
- (UIView*)mapView:(GMSMapView*)mapView markerInfoWindow:(GMSMarker*)marker {
	return [B4IObjectWrapper raiseEvent:mapView :@"_markerinfowindow:" :@[marker]];
}
#End If