// Stores the OAuth2 provider instance.
property OAuth2 : cs:C1710.NetKit.OAuth2Provider

// Stores the authenticated user's email address.
property emailAddress:=""

property credentialsFile : 4D:C1709.File
// Tokens are kept in a separate, git-ignored file so the client ID file can be shared.
property tokenFile : 4D:C1709.File

property token : Object

// Initializes the Microsoft OAuth2 configuration.
singleton Class constructor()
	
	var $file : 4D:C1709.File
	$file:=File:C1566("/PACKAGE/Credentials/Microsoft")
	
	This:C1470.credentialsFile:=$file
	This:C1470.tokenFile:=File:C1566("/PACKAGE/Credentials/Microsoft.token")
	
	var $myCredentials : Object:={}
	If ($file.exists)
		$myCredentials:=JSON Parse:C1218($file.getText())
	End if 
	
	If (This:C1470.tokenFile.exists)
		var $token : Object:=JSON Parse:C1218(This:C1470.tokenFile.getText())
		If ($token#Null:C1517) && (Not:C34(OB Is empty:C1297($token)))
			This:C1470.token:=$token
		End if 
	End if 
	
	// Build the OAuth2 configuration object
	// Object to hold OAuth2 credentials configuration
	var $credential:={}
	$credential.name:="Microsoft"  // Provider name
	$credential.permission:="signedIn"  // Requested permission level
	
	// OAuth2 client configuration
	$credential.clientId:=$myCredentials.ClientID
	$credential.redirectURI:="http://127.0.0.1:50993/authorize/"
	
	// Requested scopes
	$credential.scope:="openid email https://graph.microsoft.com/Calendars.Read https://graph.microsoft.com/Mail.Read"
	// offline → allows refresh tokens
	$credential.accessType:="offline"
	
	// Force account selection during authentication
	$credential.prompt:="select_account"
	
	// Timeout for the authentication process (in seconds)
	$credential.timeout:=120
	
	If (This:C1470.token#Null:C1517)
		$credential.token:=This:C1470.token
	End if 
	
	// Initialize the OAuth2 provider with the configuration
	This:C1470.OAuth2:=cs:C1710.NetKit.OAuth2Provider.new($credential)
	
Function loadToken() : Object
	
	var $file : 4D:C1709.File
	$file:=This:C1470.credentialsFile
	
	var $myCredentials : Object
	If ($file.exists)
		$myCredentials:=JSON Parse:C1218($file.getText())
		
	End if 
	
	return 
	
Function saveToken($token : Object)
	
	If ($token=Null:C1517) || (OB Is empty:C1297($token))
		return 
	End if 
	
	This:C1470.token:=$token
	
	This:C1470.tokenFile.setText(JSON Stringify:C1217(This:C1470.token; *))
	
	// Requests an OAuth2 token and extracts the user's email address from the ID token payload.
Function getToken() : Object
	
	// Request a token from the OAuth2 provider
	var $token:=This:C1470.OAuth2.getToken()
	
	// If a valid token is returned and contains an ID token (JWT)
	If (($token#Null:C1517) && ($token.token.id_token#Null:C1517))
		
		// Decode the JWT to access its payload
		var $openID:=cs:C1710.NetKit.JWT.new().decode($token.token.id_token)
		
		// Extract and store the email address from the token payload
		This:C1470.emailAddress:=String:C10($openID.payload.email)
		
	End if 
	
	// Return the full token object
	return $token
	
	// Retrieves Outlook categories and assigns display colors to them.
	// Algorithm: Fetches category list from Office365, maps each preset color code to RGB hex values.
	// Returns enriched collection with backgroundColor and textColor properties added to each category.
Function categoryColor() : Collection
	
	// Fetch all available Outlook categories for the authenticated user
	var $categories:=cs:C1710.NetKit.Office365.new(This:C1470.OAuth2).category.list().categories
	var $item : Object
	
	// Iterate through each category and assign Fluent UI color scheme
	For each ($item; $categories)
		Case of 
				
			: ($item.color="preset0")  // Red
				$item.backgroundColor:="#D13438"
				$item.textColor:="#FFFFFF"
				
			: ($item.color="preset1")  // Orange
				$item.backgroundColor:="#CA5010"
				$item.textColor:="#FFFFFF"
				
			: ($item.color="preset3")  // Yellow
				$item.backgroundColor:="#FFB900"
				$item.textColor:="#323130"
				
			: ($item.color="preset4")  // Green
				$item.backgroundColor:="#107C10"
				$item.textColor:="#FFFFFF"
				
			: ($item.color="preset7")  // Blue
				$item.backgroundColor:="#0078D4"
				$item.textColor:="#FFFFFF"
				
			: ($item.color="preset8")  // Purple
				$item.backgroundColor:="#5C2D91"
				$item.textColor:="#FFFFFF"
				
			Else 
				$item.backgroundColor:="#605E5C"
				$item.textColor:="#FFFFFF"
				
		End case 
	End for each 
	
	return $categories
	
	
	
	