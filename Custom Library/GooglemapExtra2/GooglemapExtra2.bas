B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
#Event: RouteResult(Point As List)
#Event: AddressResult(Address as String)
#Event: GetSnapshot(Bitmap1 As Bitmap)
#Event: SnapshotReady(Bitmap1 As Bitmap)

#IgnoreWarnings: 12

Sub Class_Globals
	Private map As GoogleMap
	Private ev As String
	Private modu As Object
	Private no As NativeObject
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Googlemap As GoogleMap)
	map = Googlemap
	no = Me
End Sub

Public Sub AddPolygon (Points As List, FillColor As Int, StrokeColor As Int)
	Dim path As NativeObject = no.RunMethod("createPath:", Array(Points))
	Dim polygon As NativeObject
	polygon = polygon.Initialize("GMSPolygon").RunMethod("polygonWithPath:", Array(path))
	polygon.SetField("map", map)
	polygon.SetField("strokeWidth", 5)
	polygon.SetField("fillColor", polygon.ColorToUIColor(FillColor))
	polygon.SetField("strokeColor", polygon.ColorToUIColor(StrokeColor))
End Sub

Sub ZoomToPoints(Points As List,Padding As Int)
	
	Dim bounds As Object = no.RunMethod("createBoundsIncluding:", Array(Points))
	Dim update As NativeObject
	update = update.Initialize("GMSCameraUpdate").RunMethod("fitBounds:withPadding:", Array(bounds, 30))
	Dim gmapNo As NativeObject = map
	gmapNo.RunMethod("animateWithCameraUpdate:", Array(update))
	
End Sub

public Sub CreateBounds (NorthEast As LatLng, SouthWest As LatLng) As Object
	Return no.RunMethod("createBounds::", Array(NorthEast, SouthWest))
End Sub

public Sub AddGroundOverlay(Bounds As Object, Image As Bitmap)
	Dim overlay As NativeObject
	overlay = overlay.Initialize("GMSGroundOverlay").RunMethod( _
		"groundOverlayWithBounds:icon:", Array(Bounds, Image))
	overlay.SetField("map", map)
End Sub

Public Sub SetSelectedMarker(Marker As Marker)
	Dim ngm As NativeObject = map
	ngm.SetField("selectedMarker", Marker)
End Sub

Public Sub ZoomPosition(Lat As Double,Lng As Double,Zoom As Float)
	
	Dim cp As CameraPosition
	cp.Initialize(Lat,Lng,Zoom)
	map.AnimateCamera(cp)
	
End Sub

Public Sub UnselectMarkers
	Dim ngm As NativeObject = map
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
	Dim ngm As NativeObject = map
	Return ngm.GetField("projection")
End Sub

Public Sub GetVisibleBounds As NativeObject
	Dim Bounds As NativeObject
	Bounds = no.RunMethod("coordinateBoundsFromProjection:", Array(GetProjection))
	Return Bounds
End Sub

Public Sub GetBoundsNE_SW (bounds As Object) As LatLng()
	Dim ne, sw As LatLng
	no.RunMethod("getLatLngFromBounds:::", Array(bounds, ne, sw))
	Return Array As LatLng(ne, sw)
End Sub

Public Sub BoundsContain(Bounds As NativeObject, LatLng As LatLng) As Boolean
	Return no.RunMethod("boundsContain::", Array(Bounds, LatLng)).AsBoolean
End Sub

Public Sub MapStyle (json As String)
	Dim ngm As NativeObject = map
	Dim style As Object = no.RunMethod("createMapStyle:", Array(json))
	ngm.SetField("mapStyle", style)
End Sub

Public Sub ChangeMapPosition(Lat As Double,Lon As Double,X As Int,Y As Int)

	Dim Point1() As Double
	Dim LatLng1 As LatLng
       
	LatLng1.Initialize(Lat,Lon)
	Point1 = CoordinateToScreen(LatLng1)
	
	Point1(0)	=	Point1(0) + x
	Point1(1) 	=	Point1(1) +  y
   
   	Dim lt As LatLng
	lt = ScreenToCoordinate(Point1(0),Point1(1))
	
	Dim CameraPosition1 As CameraPosition
	CameraPosition1.Initialize(lt.Latitude, lt.Longitude, map.CameraPosition.Zoom)
	map.AnimateCamera(CameraPosition1)
	
End Sub

Public Sub ScreenToCoordinate(X As Double, Y As Double) As LatLng
	Return no.RunMethod("screenToCoordinate:::", Array(GetProjection, X, Y))
End Sub

'Returns x, y
Public Sub CoordinateToScreen(Location As LatLng) As Double()
	Dim arr As NativeObject = no.RunMethod("coordinateToScreen::", Array(GetProjection, Location))
	Return Array As Double(arr.RunMethod("objectAtIndex:", Array(0)).AsNumber, _
		arr.RunMethod("objectAtIndex:", Array(1)).AsNumber)
End Sub

'Adds a circle at the given point.
'Radius is measured in meters.
Public Sub AddCircle (Lat As Double, Lon As Double, Radius As Double, Color As Int)
	Dim circle As NativeObject = no.RunMethod("createCircle:::", Array(Lat, Lon, Radius))
	circle.SetField("map", map)
	circle.SetField("strokeWidth", 5)
	circle.SetField("fillColor", circle.ColorToUIColor(Color))
	circle.SetField("strokeColor", circle.ColorToUIColor(Color))
	
End Sub

Sub SearchPlace(Place As String)
	
	Dim su As StringUtils
	Dim ht As HttpJob
	Dim url As String
	
	ht.Initialize("search",Me)
	url = $"https://maps.googleapis.com/maps/api/place/autocomplete/json?sensor=false&input=${su.EncodeUrl(Place,"UTF8")}&types=geocode&language=fa&key=AIzaSyDh7SXTxhEbh0NIzbOrEXOcDIZ0m16yksM"$
	ht.Download(url)
	
End Sub

Sub GetLocationAddress(Lat As String,Lon As String,Module As Object,Event As String)
	
	ev = Event & "_addressresult"
	modu = Module
	
	Dim ht As HttpJob
	ht.Initialize("get_information",Me)
	ht.Download($"https://maps.google.com/maps/api/geocode/json?latlng=${Lat},${Lon}&sensor=False&language=fa"$)
	
End Sub

Sub GetRoutes(From As Location,sTo As Location,Module As Object,Event As String)
	
	ev = Event & "_routeresult"
	modu = Module
	
	Dim h As HttpJob
	h.Initialize("route",Me)
	h.Download("http://maps.googleapis.com/maps/api/directions/json?origin=" & From.Latitude & "," & From.Longitude & "&destination=" & sTo.Latitude & "," & sTo.Longitude & "&sensor=false&region=it")
	
End Sub

Sub GetLocationsDistanceDuration(ChoosenStartLocation As Location,ChoosenEndLocation As Location)
	
	Dim ht As HttpJob
	ht.Initialize("distance",Me)
	ht.Download($"https://maps.googleapis.com/maps/api/directions/json?origin=${ChoosenStartLocation.Latitude},${ChoosenStartLocation.Longitude}&destination=${ChoosenEndLocation.Latitude},${ChoosenEndLocation.Longitude}&sensor=false&mode=driving&alternatives=true&language=fa"$)
	
End Sub

Sub GetLatLng(Latitude As Double,Longitude As Double) As LatLng
	Dim lt As LatLng
	lt.Initialize(Latitude,Longitude)
	Return lt
End Sub

Sub Distance(sStart As LatLng,sEnd As LatLng) As Double
	
	Dim Start,Finish As Location
	Start.Initialize2(sStart.Latitude,sStart.Longitude)
	Finish.Initialize2(sEnd.Latitude,sEnd.Longitude)
	
	Return Start.DistanceTo(Finish)
	
End Sub

Private Sub JobDone(Job As HttpJob)
	
	If Job.Success Then
		If Job.JobName = "route" Then
			Dim JSONParser1 As JSONParser
			JSONParser1.Initialize(Job.GetString2("UTF8"))
			
			Dim Map1 As Map
			Map1=JSONParser1.NextObject
			
			Dim status As String
			If Map1.ContainsKey("status") And Map1.ContainsKey("routes") Then
				status=Map1.Get("status")
				
				If status="OK" Then
					Dim routes, steps As List
					Dim legs As List
					Dim m1, m2 As Map
					Dim EndLocation As LatLng
				 
					Dim lMapsPoints As List
					lMapsPoints.Initialize
				 
					routes=Map1.Get("routes")
					m1=routes.Get(0)        ' prendo solo il primo itinerario perchè non è specificato di proporne multipli
					legs=m1.Get("legs")
					m1=legs.Get(0)        ' prendo solo il primo legs perchè non ci sono waypoints
					steps=m1.Get("steps")
					 
					Dim points As List
					points.Initialize
					
					If steps.Size>0 Then
						For s=0 To steps.Size-1
							m1=steps.Get(s)
							m2=m1.Get("end_location")
							EndLocation.Initialize(m2.Get("lat"),m2.Get("lng"))
							m2=m1.Get("polyline")
							MapsDecodePolyline(m2.Get("points"),points)
							CallSubDelayed2(modu,ev,points)
							Return
						Next
						
					End If
				End If
			End If
		
		Else if Job.JobName = "search" Then
			Dim rs As Map
			Dim ls As List
			rs = Json2Map(Job.GetString2("UTF8"))
			ls = rs.Get("predictions")
			CallSubDelayed2(modu,ev,ls)
			Return
			
		Else If Job.JobName.StartsWith("get_information") Then
			
			Dim r2 As Map
			Dim r3 As List
			r2 = Json2Map(Job.GetString2("UTF8"))
			r3 = r2.Get("results")
			
			If r3 = Null Then Return
			If r3.IsInitialized = False Then Return
			If r3.Size = 0 Then Return
			
			r2 = r3.Get(0)
			
			Dim add As String
			add = ParseAddress(r2.Get("formatted_address"),False)
			
			CallSubDelayed2(modu,ev,add)
			Return
			
		End If
		
	Else if Job.JobName = "distance" Then
		Dim JSONParser1 As JSONParser
		JSONParser1.Initialize(Job.GetString2("UTF8"))
			
		Dim Map1 As Map
		Map1=JSONParser1.NextObject
			
		Dim status As String
		If Map1.ContainsKey("status") And Map1.ContainsKey("routes") Then
			status=Map1.Get("status")
				
			If status="OK" Then
				Dim routes, steps As List
				Dim legs As List
				Dim m1, m2 As Map
				Dim EndLocation As LatLng
				 
				Dim lMapsPoints As List
				lMapsPoints.Initialize
				 
				routes=Map1.Get("routes")
				m1=routes.Get(0)        ' prendo solo il primo itinerario perchè non è specificato di proporne multipli
				legs=m1.Get("legs")
				m1=legs.Get(0)        ' prendo solo il primo legs perchè non ci sono waypoints
				steps=m1.Get("steps")
					 
				Dim points As List
				points.Initialize
					
				If steps.Size>0 Then
					For s=0 To steps.Size-1
						m1=steps.Get(s)
						m2=m1.Get("end_location")
						EndLocation.Initialize(m2.Get("lat"),m2.Get("lng"))
						CallSubDelayed2(modu,ev,m1)
						Return
					Next
						
				End If
			End If
		End If
	End If
	
	CallSubDelayed2(modu,ev,points)
	
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

Sub Snapshot(Module As Object,Event As String,Page1 As Page)
	
	ev = Event & "_getsnapshot"
	
	Dim ev2 As String
	ev2	= Event & "_snapshotready"
	
	Dim iv As ImageView
	iv.Initialize("")
	Page1.RootPanel.AddView(iv,0,0,map.Width,map.Height)
	iv.Visible	=	False
	
	Dim cvs As Canvas
	cvs.Initialize(iv)
	Dim dest As Rect
	dest.Initialize(0, 0, map.Width, map.Height)
	cvs.DrawView(map, dest)
	cvs.Refresh
	
	If SubExists(Module,ev2,1) Then
		CallSub2(Module,ev2,cvs.CreateBitmap)
		Return
	End If
	
	CallSubDelayed2(Module,Event & "_getsnapshot",cvs.CreateBitmap)
	
End Sub

Sub ParseAddress(Address As String,IsArray As Boolean) As Object
	
	Dim rs() As String
	Dim res As List
	res.Initialize
	
	Try
		If Address.IndexOf("،") > -1 Then
			rs = Regex.Split("،",Address)
			
		Else if Address.IndexOf(",") > -1 Then
			rs = Regex.Split(",",Address)
		Else
			
			Return Address
		End If
			
		If rs.Length = 1 Then Return rs(0)
		If rs.Length = 2 Then Return Address
		
		For i = 1 To rs.Length - 2
			res.Add(rs(i))
		Next
		
		If IsArray Then Return res
		
		Dim result As String
		For j = 0 To res.Size - 1
			result = result & "," & res.Get(j)
		Next
		Return result.SubString(1)
	Catch
		Return ""
	End Try
	
End Sub

Public Sub SetInfoWindowAnchor(Marker As Marker, X As Double, Y As Double)
	Dim m As NativeObject = Marker
	m.RunMethod("setInfoWindowAnchor:", Array(m.MakePoint(X, Y)))
End Sub

Sub GetDirectionLocation(StartLocation As LatLng,EndLocation As LatLng) As Float
	
	Dim angle As Float
	angle	=	finalBearing(StartLocation.Latitude, StartLocation.Longitude, EndLocation.Latitude, EndLocation.Longitude)
	Return angle
	
End Sub

Private Sub finalBearing(lat1 As Double,long1 As Double,lat2 As Double,long2 As Double) As Double
	Return  Bit.FMod((bearing(lat2, long2, lat1, long1) + 180.0),360)
End Sub

Private Sub bearing(lat1 As Double,long1 As Double,lat2 As Double,long2 As Double) As Double
	
	Dim degToRad,phi1,phi2,lam1,lam2 As Double
	degToRad = cPI / 180.0
	phi1 = lat1 * degToRad
	phi2 = lat2 * degToRad
	lam1 = long1 * degToRad
	lam2 = long2 * degToRad

	Return ATan2(Sin(lam2-lam1)*Cos(phi2),Cos(phi1)*Sin(phi2) - Sin(phi1)*Cos(phi2)*Cos(lam2-lam1)) * 180/cPI
		
End Sub

Private Sub Map2Json(Data As Map) As String
	
	If Data = Null Then Return "{}"
	If Data.IsInitialized = False Then Return "{}"
	
	Dim js As JSONGenerator
	js.Initialize(Data)
	Return js.ToString
	
End Sub

Private Sub Json2Map(Data As String) As Map
	
	Dim js As JSONParser
	js.Initialize(Data)
	Return js.NextObject
	
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