// Path to the calendar resource file.
property _FilePath : Text:=Folder:C1567(fk resources folder:K87:11).file("Scheduler.sjs").platformPath
// Name of the View Pro area hosting the calendar.
property _VPArea : Text:="ViewProArea"
// Calendar display helper used by the form.
property _calendarDisplay : Object

// Creates the calendar display helper.
Class constructor
	This:C1470._calendarDisplay:=cs:C1710.CalendarDisplay.new(This:C1470._VPArea)
	
	VP IMPORT DOCUMENT(This:C1470._VPArea; This:C1470._FilePath; {formula: This:C1470.initCalendar})
	
	// Displays the supplied events in the calendar.
Function displayCalendar($events : Collection)
	This:C1470._calendarDisplay.displayCalendar($events)
	
	// Initializes the calendar grid and current-day indicators.
Function initCalendar()
	
	var $this : cs:C1710.Form_Calendar
	$this:=Form:C1466.calendar
	
	$this._calendarDisplay.initCalendar()