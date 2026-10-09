// Polling interval used by the notification handler.
property timer:=10
// Office 365 client used to retrieve calendar events.
property office365 : cs:C1710.NetKit.Office365

// Stores the current system time zone for calendar event retrieval.
property currentTimeZone:=cs:C1710.DateTimeUtils.TimeZone.new().current

// Stores the Office 365 client used by this handler.
Class constructor($office365 : cs:C1710.NetKit.Office365)
	
	This:C1470.office365:=$office365
	
	// Retrieves and displays calendar events reported by the notification.
	// Algorithm: Fetches new events from Office365 API and syncs them to the calendar view.
	// Iterates through event IDs, retrieves full event data with timezone conversion, 
	// filters null results, and batch-renders all events in single display call.
	
Function getCalendarObjects() : Collection
	
	var $objects : Collection
	$objects:=[]
	var $objectName : Text
	var $i : Integer
	ARRAY TEXT:C222($objectNames; 0)
	FORM GET OBJECTS:C898($objectNames)
	For ($i; 1; Size of array:C274($objectNames))
		$objectName:=$objectNames{$i}
		If (OBJECT Get type:C1300(*; $objectName)=Object type view pro area:K79:43)
			$objects.push($objectName)
		End if 
	End for 
	
	return $objects
	
Function onCreate($provider : Object; $event : Object)
	
	var $id : Text
	var $events:=[]
	var $myEvent : Object
	
	// Batch fetch all new event details from Office365
	For each ($id; $event.ids)
		// Request full event data with timezone applied to start/end times
		$myEvent:=This:C1470.office365.calendar.getEvent({eventId: $id; timeZone: This:C1470.currentTimeZone.MicrosoftTimeZone})
		
		// Only add successfully retrieved events to collection
		If ($myEvent#Null:C1517)
			$events.push($myEvent)
		End if 
	End for each 
	
	If ($events.length=0)
		return 
	End if 
	
	var $objects : Collection
	var $object : Text
	$objects:=This:C1470.getCalendarObjects()
	For each ($object; $objects)
		var $calendar:=cs:C1710.CalendarDisplay.new($object)
		// Render all fetched events in single calendar update
		$calendar.displayCalendar($events)
	End for each 
	
	// Removes calendar events reported as deleted.
	// Algorithm: Iterates through deleted event IDs and removes corresponding shapes from calendar grid.
Function onDelete($provider : Object; $event : Object)
	
	var $objects : Collection
	var $object : Text
	$objects:=This:C1470.getCalendarObjects()
	For each ($object; $objects)
		var $id : Text
		var $calendar:=cs:C1710.CalendarDisplay.new($object)
		
		// Remove all events reported as deleted from the display
		For each ($id; $event.ids)
			// Remove the shape/rendering for this event ID
			$calendar.removeEvent($id)
		End for each 
	End for each 
	
	// Retrieves and updates calendar events reported as modified.
	// Algorithm: Fetches updated event details and refreshes calendar display.
	// Requests full event data with timezone conversion and updates shape if event found.
Function onModify($provider : Object; $event : Object)
	
	var $id : Text
	var $events:=[]
	var $myEvent : Object
	
	// Batch fetch all modified event details from Office365
	For each ($id; $event.ids)
		// Request full event data with timezone applied
		$myEvent:=This:C1470.office365.calendar.getEvent({eventId: $id; timeZone: This:C1470.currentTimeZone.MicrosoftTimeZone})
		
		// Keep only events retrieved successfully
		If ($myEvent#Null:C1517)
			$events.push({id: $id; event: $myEvent})
		End if 
	End for each 
	
	If ($events.length=0)
		return 
	End if 
	
	var $objects : Collection
	var $object : Text
	var $modified : Object
	$objects:=This:C1470.getCalendarObjects()
	For each ($object; $objects)
		var $calendar:=cs:C1710.CalendarDisplay.new($object)
		// Update the shape of each modified event
		For each ($modified; $events)
			$calendar.updateEvent($modified.id; $modified.event)
		End for each 
	End for each 
	