// Path to the calendar resource file.
property _FilePath : Text:=Folder:C1567(fk resources folder:K87:11).file("Scheduler.sjs").platformPath
// Name of the View Pro area hosting the calendar.
property _VPArea : Text
// Calendar display helper used by the form.
property _calendarDisplay : Object

// Creates the calendar display helper.
Class constructor($objectName : Text)
	
	This:C1470._VPArea:=$objectName
	This:C1470._calendarDisplay:=cs:C1710.CalendarDisplay.new(This:C1470._VPArea)
	
	CALL FORM:C1391(Current form window:C827; This:C1470.loadCalendar)
	
Function loadCalendar()
	
	VP IMPORT DOCUMENT(Form:C1466.calendar._VPArea; Form:C1466.calendar._FilePath; {formula: Form:C1466.calendar.initCalendar})
	
	// Displays the supplied events in the calendar.
Function displayCalendar($events : Collection)
	This:C1470._calendarDisplay.displayCalendar($events)
	
	// Initializes the calendar grid and current-day indicators.
Function initCalendar($objectName : Text; $path : Text; $context : Object; $status : Object)
	
	If ($status.success)
		Form:C1466.calendar._calendarDisplay.initCalendar($objectName)
	End if 