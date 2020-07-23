B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=5.3
@EndOfDesignText@
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Private Sub EncryptRSAWithPublicKey(Text As String,PublicKey As String) As String
   
    #If B4I
	Dim su As StringUtils
	Dim rsa As RSA
	Return su.EncodeBase64(rsa.EncryptWithPublicKey(Text.GetBytes("UTF8"),PublicKey))
    #Else
   
    Dim su As StringUtils
    Dim pubkey() As Byte = su.DecodeBase64(PublicKey)
    Dim Enc As Cipher
    Enc.Initialize("RSA/ECB/PKCS1Padding")
    Dim kpg As KeyPairGenerator
    kpg.Initialize("RSA", 1024)
    kpg.PublicKeyFromBytes(pubkey)
    Dim bytes() As Byte = Text.GetBytes("UTF8")

    Return su.EncodeBase64(Enc.Encrypt(bytes,kpg.PublicKey,False))
   
    #End If
   
End Sub

Private Sub DecryptRSAWithPrivateKey(encryptedstring As String,PrivateKey As String) As String
   
    #If B4J
   
    #AdditionalJar: bcprov-jdk15on-161.jar

    #if java
    import org.bouncycastle.jce.provider.BouncyCastleProvider;
    import java.security.Provider;
    import java.security.Security;
    static{
     Provider BC = new BouncyCastleProvider();
     Security.addProvider(BC);
    }
    #End If
   
    #End if
   
    #If B4A or B4J
   
    Dim su As StringUtils
    Dim privkey() As Byte = su.DecodeBase64(PrivateKey)
    Dim kpg As KeyPairGenerator
    kpg.Initialize("RSA", 1024)
    kpg.PrivateKeyFromBytes(privkey)
    Dim Enc As Cipher
    Enc.Initialize("RSA/ECB/PKCS1Padding")
    Dim bc As ByteConverter
    Return bc.StringFromBytes(Enc.Decrypt(su.DecodeBase64(encryptedstring),kpg.PrivateKey,False),"UTF8")
   
    #End If
   
End Sub