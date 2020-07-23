B4i=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=4.3
@EndOfDesignText@
'version 1.00
#Event: Available (Success As Boolean, Contacts As List)
Sub Class_Globals
	Public contacts As Contacts
	Private mTarget As Object
	Private mEventName As String
	Private contactsFormatter As NativeObject
	Type cuContact (DisplayName As String, CachedContact As NativeObject,Phones As List)
	Type cuPhone (Number As String, PhoneType As String)
	Type cuEmail (Email As String, EmailType As String)
	Type cuDate (Year As Int, Month As Int, Day As Int, DateType As String)
End Sub

Public Sub Initialize (TargetModule As Object, EventName As String)
	mTarget = TargetModule
	mEventName = EventName
	contactsFormatter.Initialize("CNContactFormatter")
End Sub

Public Sub GetPhonesWithID(ID As String) As List
	
End Sub

'Returns True if the user has previously denied access to the contacts feature.
Public Sub AuthorizationDenied As Boolean
	Return contacts.AuthorizationDenied
End Sub

Private Sub GetDefaultKeys As List
	Return Array(contacts.ContactIdentifierKey, _
		contactsFormatter.RunMethod("descriptorForRequiredKeysForStyle:", Array(0)))
End Sub

'Asynchronously reads all the contacts. The Available event will be raised when the data is ready.
'PrefetchKeys - A list of keys to prefetch as an optimization.
Public Sub GetContacts (PrefetchKeys As List)
	Dim keysToFetch As List = GetDefaultKeys
	If PrefetchKeys.IsInitialized Then keysToFetch.AddAll(PrefetchKeys)
	Sleep(500)
	contacts.GetContacts(keysToFetch, "contacts")
End Sub

Private Sub contacts_GetContacts (Success As Boolean, contacts1 As List)
	Dim result As List
	result.Initialize
	If Success Then
		For Each c As Object In contacts1
			Dim cu As cuContact
			cu.Initialize
			cu.CachedContact = c
			cu.DisplayName = NoToString(contactsFormatter.RunMethod("stringFromContact:style:", Array(c, 0)), "N/A")
			result.Add(cu)
		Next
	Else
		Log("Error reading contacts: " & LastException)
	End If
	CallSub3(mTarget, mEventName  & "_available", Success, result)
End Sub

Public Sub GetIdentifier(cc As NativeObject) As String
	Return cc.GetField(contacts.ContactIdentifierKey).AsString
End Sub

'Returns a List of cuPhone items.
Public Sub GetPhones(cu As cuContact) As List
	Dim phones As List
	phones.Initialize
	For Each No As NativeObject In GetListForKey(cu, contacts.ContactPhoneNumbersKey)
		Dim p As cuPhone
		p.Initialize
		p.PhoneType = NoToString(No.GetField("label"), "Other")
		p.Number = No.GetField("value").GetField("stringValue").AsString
		phones.Add(p)
	Next
	Return phones
End Sub

'Sets the phone numbers. Phones should be a List of cuPhone items.
Public Sub SetPhones(cu As cuContact, Phones As List)
	Dim Labeled As List
	Labeled.Initialize 
	Dim pn As NativeObject
	pn.Initialize("CNPhoneNumber")
	For Each cp As cuPhone In Phones
		Labeled.Add(CreateLabeledValue(cp.PhoneType, pn.RunMethod("phoneNumberWithStringValue:", Array(cp.Number))))
	Next
	UpdateContact(cu, contacts.ContactPhoneNumbersKey, Labeled)
End Sub

Private Sub CreateLabeledValue(Label As String, Value As Object) As Object
	Dim no As NativeObject
	If Label = "Home" Or Label = "Work" Or Label = "Other" Then Label = $"_$!<${Label}>!$_"$
	Return no.Initialize("CNLabeledValue").RunMethod("alloc", Null).RunMethod("initWithLabel:value:", Array(Label, Value))
End Sub

Private Sub NoToString(no As NativeObject, DefaultValue As String) As String
	If no.IsInitialized = False Then Return DefaultValue
	Return no.AsString.Replace("_$!<", "").Replace(">!$_", "")
End Sub

'Sets the emails. Emails should be a List of cuEmail items.
Public Sub SetEmails(cu As cuContact, Emails As List)
	Dim Labeled As List
	Labeled.Initialize
	For Each cp As cuEmail In Emails
		Labeled.Add(CreateLabeledValue(cp.EmailType, cp.Email))
	Next
	UpdateContact(cu, contacts.ContactEmailAddressesKey, Labeled)
End Sub
'Returns a List of cuEmail items.
Public Sub GetEmails(cu As cuContact) As List
	Dim emails As List
	emails.Initialize
	For Each No As NativeObject In GetListForKey(cu, contacts.ContactEmailAddressesKey)
		Dim e As cuEmail
		e.Initialize
		e.EmailType = NoToString(No.GetField("label"), "Other")
		e.Email = NoToString(No.GetField("value"), "")
		emails.Add(e)
	Next
	Return emails
End Sub
'Returns the contact's photo as a thumbnail. Returns an uninitialized Bitmap if there is no photo.
Public Sub GetPhotoThumbnail(cu As cuContact) As Bitmap
	Return GetPhotoImpl(cu, contacts.ContactThumbnailImageDataKey)
End Sub
'Returns the contact's photo. Returns an uninitialized Bitmap if there is no photo.
Public Sub GetPhoto(cu As cuContact) As Bitmap
	Return GetPhotoImpl(cu, contacts.ContactImageDataKey)
End Sub

Private Sub GetPhotoImpl (cu As cuContact, key As String) As Bitmap
	VerifyKeys(cu, Array(key))
	Dim raw As NativeObject = cu.CachedContact.GetField(key)
	If raw.IsInitialized Then
		Dim bytes() As Byte = raw.NSDataToArray(raw)
		Dim in As InputStream
		in.InitializeFromBytesArray(bytes, 0, bytes.Length)
		Dim bmp As Bitmap
		bmp.Initialize2(in)
		in.Close
		Return bmp
	End If
	Return Null
End Sub
'Sets the contact's photo.
Public Sub SetPhoto(cu As cuContact, Photo As Bitmap)
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	Photo.WriteToStream(out, 100, "PNG")
	Dim no As NativeObject 'ignore
	UpdateContact(cu, contacts.ContactImageDataKey, no.ArrayToNSData(out.ToBytesArray))
End Sub
'Gets the contacts Note.
Public Sub GetNote(cu As cuContact) As String
	VerifyKeys(cu, Array(contacts.ContactNoteKey))
	Return NoToString (cu.CachedContact.GetField(contacts.ContactNoteKey), "")
End Sub
'Sets the contacts Note.
Public Sub SetNote(cu As cuContact, Note As String)
	UpdateContact(cu, contacts.ContactNoteKey, Note)
End Sub

Private Sub UpdateContact(cu As cuContact, Key As String, Value As Object)
	Dim saveRequest As NativeObject = CreateSaveRequest
	VerifyKeys(cu, Array(Key))
	Dim mutable As NativeObject = cu.CachedContact.RunMethod("mutableCopy", Null)
	mutable.SetField(Key, Value)
	saveRequest.RunMethod("updateContact:", Array(mutable))
	contacts.ExecuteSaveRequest(saveRequest)
End Sub

Private Sub CreateSaveRequest As NativeObject
	Dim saveRequest As NativeObject
	Return saveRequest.Initialize("CNSaveRequest").RunMethod("new", Null)
End Sub
'Inserts a new contact. Returns the contact created. You can use it to set more fields.
Public Sub InsertContact (GivenName As String, FamilyName As String) As cuContact
	Dim saveRequest As NativeObject = CreateSaveRequest
	Dim mutable As NativeObject
	mutable = mutable.Initialize("CNMutableContact").RunMethod("new", Null)
	mutable.SetField(contacts.ContactGivenNameKey, GivenName)
	mutable.SetField(contacts.ContactFamilyNameKey, FamilyName)
	saveRequest.RunMethod("addContact:toContainerWithIdentifier:", Array(mutable, Null))
	contacts.ExecuteSaveRequest(saveRequest)
	Dim cu As cuContact
	cu.Initialize
	cu.CachedContact = contacts.GetContactByIdentifier(GetIdentifier(mutable), GetDefaultKeys)
	cu.DisplayName = NoToString(contactsFormatter.RunMethod("stringFromContact:style:", Array(cu.CachedContact, 0)), "N/A")
	Return cu
End Sub
'Deletes a contact.
Public Sub DeleteContact (cu As cuContact)
	Dim saveRequest As NativeObject = CreateSaveRequest
	Dim mutable As NativeObject = cu.CachedContact.RunMethod("mutableCopy", Null)
	saveRequest.RunMethod("deleteContact:", Array(mutable))
	contacts.ExecuteSaveRequest(saveRequest)
End Sub
'Returns the contact's birthday. Note that the year will be -1 if the year is not set.
'Returns Null if there is no birthday set.
Public Sub GetBirthday(cu As cuContact) As cuDate
	VerifyKeys(cu, Array(contacts.ContactBirthdayKey))
	Dim no As NativeObject = cu.CachedContact.GetField("birthday")
	If no.IsInitialized = False Then Return Null
	Dim d As cuDate
	d.Initialize
	d.DateType = "Birthday"
	SetCuDateFromNative(no, d)
	Return d
End Sub

'Returns the contact's dates. Returns a List of cuDate items.
Public Sub GetDates(cu As cuContact) As List
	Dim dates As List
	dates.Initialize
	For Each No As NativeObject In GetListForKey(cu, contacts.ContactDatesKey)
		Dim d As cuDate
		d.Initialize
		d.DateType = NoToString(No.GetField("label"), "Other")
		SetCuDateFromNative(No.GetField("value"), d)
		dates.Add(d)	
	Next
	Return dates
End Sub

Private Sub SetCuDateFromNative(no As NativeObject, d As cuDate)
	d.Day = no.GetField("day").AsNumber
	d.Month = no.GetField("month").AsNumber
	d.Year = no.GetField("year").AsNumber
	If d.Year = 0x7fffffff Then d.Year = -1
End Sub

Private Sub GetListForKey(cu As cuContact, Key As String) As List
	VerifyKeys(cu, Array(Key))
	Dim rawPhones As List = cu.CachedContact.GetField(Key)
	Return rawPhones
End Sub

Private Sub VerifyKeys(cu As cuContact, keys As List)
	If cu.CachedContact.RunMethod("areKeysAvailable:", Array(keys)).AsBoolean Then
		
	Else
		keys.Add(contacts.ContactIdentifierKey)
		cu.CachedContact = contacts.GetContactByIdentifier(GetIdentifier(cu.CachedContact), keys)
	End If
End Sub
