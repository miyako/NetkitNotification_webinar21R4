//%attributes = {"invisible":true}
#DECLARE($providerName : Text) : Boolean

var $providerClass : 4D:C1709.Class
var $emailKind : Text

Case of 
	: ($providerName="Microsoft")
		$providerClass:=cs:C1710.OfficeProvider
		$emailKind:="microsoftEmailAddress"
	Else 
		return 
End case 

// Retrieve the authentication token
// This may open a web browser if user login/consent is required
var $token : Object:=Try($providerClass.me.getToken())

// Proceed only if we have a valid token and a non-empty email address
If (($token#Null:C1517) && ($providerClass.me.emailAddress#""))
	
	$providerClass.me.saveToken($token)
	
	// Store the authenticated user's email address in the form.
	Form:C1466[$emailKind]:=$providerClass.me.emailAddress
	
	return True:C214
Else 
	ALERT:C41("Sign-in error: unable to obtain authentication token")
	return False:C215
End if 