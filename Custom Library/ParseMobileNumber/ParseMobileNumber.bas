B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=5
@EndOfDesignText@
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Sub ParsePhoneNumber(Phone As String) As String
	
	If Phone.StartsWith("*") Or Phone.StartsWith("#") Then Return ""
	
	Phone	=	Phone.Replace(" ","")
	
	Dim sim_country_code As String
	Dim validator As PhoneNumberUtil
	validator.Initialize
	
	sim_country_code	=	Poolma.manager.GetString("simcard_iso")
	sim_country_code	=	sim_country_code.ToUpperCase
	
	If sim_country_code.Length = 0 Then
		sim_country_code	=	GetSimcardIsoCode
	End If
	
	Try
		#if debug
		sim_country_code	=	"IR"
		#End If
		If validator.Is_valid(Phone,sim_country_code) Then
			
			Dim res As String
			res	=	validator.Parse2(Phone,sim_country_code)
			res	=	res.Replace("+","").Replace(" ","")
			Return res
			
		Else
			Return Validation.ParsePhoneNumber(Phone)
			
		End If
	Catch
		Return Phone
	End Try
		
End Sub

Public Sub GetSimcardIsoCode As String
	
	Dim no As NativeObject
	no = no.Initialize("CTTelephonyNetworkInfo")
	no = no.RunMethod("new", Null).RunMethod("subscriberCellularProvider", Null)
	
	If no.IsInitialized Then
		Return 	no.GetField("isoCountryCode").AsString
	Else
		Return ""
	End If
	
End Sub