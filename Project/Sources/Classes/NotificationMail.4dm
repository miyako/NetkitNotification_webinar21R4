// Polling interval used by the notification handler.
property timer:=10
// Office 365 client used to retrieve mail items.
property office365 : cs:C1710.NetKit.Office365

// Stores the Office 365 client used by this handler.
Class constructor($office365 : cs:C1710.NetKit.Office365)
	This:C1470.office365:=$office365
	
	// Adds newly received mail items to the form collection.
	// Algorithm: Fetches mail metadata from Office365 API and appends to form collection with green highlight.
Function onCreate($provider : Object; $event : Object)
	var $item : Object
	var $id : Text
	
	// Process each new mail item ID from notification
	For each ($id; $event.ids)
		// Request full mail item details from Office365
		$item:=This:C1470.office365.mail.getMail($id)
		
		// Prepend new mail to form collection with metadata and new-mail indicator
		Form:C1466.emails.unshift({type: $event.type; sender: $item.sender; subject: $item.subject; id: String:C10($id); sentDateTime: $item.sentDateTime; rowColor: "Green"})
		
	End for each 
	
	// Removes deleted mail items from the form collection.
	// Algorithm: Uses collection query to find matching email by ID, then removes from display list.
Function onDelete($provider : Object; $event : Object)
	var $indice : Collection
	var $id : Text
	
	// Iterate through deleted mail item IDs
	For each ($id; $event.ids)
		// Search form collection for matching email ID
		$indice:=Form:C1466.emails.indices("id = :1"; $id)
		
		// Remove first matching item if found
		If ($indice.length>0)
			Form:C1466.emails.remove($indice[0])
		End if 
		
	End for each 
	
	// Updates modified mail items in the form collection.
	// Algorithm: Finds email in collection by ID, fetches updated metadata, replaces row with orange highlight.
Function onModify($provider : Object; $event : Object)
	var $item : Object
	var $indice : Collection
	var $id : Text
	
	// Iterate through modified mail item IDs
	For each ($id; $event.ids)
		// Search form collection for matching email ID
		$indice:=Form:C1466.emails.indices("id = :1"; $id)
		
		// Update if email found in collection
		If ($indice.length>0)
			// Request updated mail item details from Office365
			$item:=This:C1470.office365.mail.getMail($id)
			
			// Sync notification type to mail item
			$item.type:=$event.type
			
			// Replace collection entry with updated metadata and modified-mail indicator
			Form:C1466.emails[$indice[0]]:={type: $event.type; sender: $item.sender; subject: $item.subject; id: String:C10($id); sentDateTime: $item.sentDateTime; rowColor: "Orange"}
			
		End if 
		
	End for each 