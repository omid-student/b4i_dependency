Type=StaticCode
Version=1.8
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.
	Private no As NativeObject=Me
End Sub

Sub Initialize
no.RunMethod("pt",Null)

End Sub

Sub AddContact(FirstName As String,LastName As String, PhoneNumber As String, Image As Bitmap)
no.RunMethod("addPetToContacts::::",Array(FirstName,LastName,PhoneNumber,Image))

End Sub

#If OBJC  
@import AddressBook;


//NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);

- (void)pt
{
  if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
      ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
    //1
    NSLog(@"Denied");
  } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
    //2
    NSLog(@"Authorized");
  } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
  if (!granted){
    //4
    NSLog(@"Just denied");
    return;	
  }
  //5
  NSLog(@"Just authorized");
});
    NSLog(@"Not determined");
  }
}


- (void)addPetToContacts: (NSString *) FirstName :(NSString *) LastName :(NSString *) PhoneNumber :(UIImage *) Image
{
 NSString *petFirstName;
NSString *petLastName;
NSString *petPhoneNumber;
NSData *petImageData;

{
  petFirstName = @"Cat";
  petLastName = @"Cat";
  petPhoneNumber = @"2015552398";
  petImageData = UIImageJPEGRepresentation(Image, 0.7f);

  //petImageData=image
}

ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
ABRecordRef pet = ABPersonCreate();
ABRecordSetValue(pet, kABPersonFirstNameProperty, (__bridge CFStringRef)FirstName, nil);
ABRecordSetValue(pet, kABPersonLastNameProperty, (__bridge CFStringRef)LastName, nil);

ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABPersonPhoneProperty);
ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)PhoneNumber, kABPersonPhoneMainLabel, NULL);
ABRecordSetValue(pet, kABPersonPhoneProperty, phoneNumbers, nil);
ABPersonSetImageData(pet, (__bridge CFDataRef)petImageData, nil);

NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);

BOOL isAdded = ABAddressBookAddRecord(addressBookRef, pet, nil);

if(isAdded){
		
		NSLog(@"added..");
	}
	
	
	
	
	
	
BOOL isSaved = ABAddressBookSave(addressBookRef, nil);

if(isSaved){
		
		NSLog(@"saved..");
	}

}

/////////////////////




#End if

