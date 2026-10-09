// Name of the View Pro area used to render the calendar.
property _VPArea : Text
// Time slots displayed by the calendar.
property _timeSlot:=[]
// Column corresponding to the current day.
property _currentDayColumn:=1
// Colors used to highlight the current date.
property _backColorCurrentDate:="#DBEAFE"
property _foreColorCurrentDate:="#1E40AF"
// Default colors used for events without a category.
property _defaultBackColorDate:="#CBD5E1"
property _defaultForeColorDate:="#1F2937"
// Row indexes for the all-day section and the time grid.
property _allDayRow:=2
property _firstCalendarRow:=3
// First column of the calendar grid.
property _firstCalendarColumn:=1

// Initializes the View Pro area and creates five-minute time slots.
Class constructor($vpArea : Text)
	
	If ($vpArea#"")
		This:C1470._VPArea:=$vpArea
	End if 
	
	var $currentTime:=?08:00:00?
	While ($currentTime<=?21:00:00?)
		This:C1470._timeSlot.push($currentTime)
		$currentTime:=$currentTime+?00:05:00?
	End while 
	
	// Adds all supplied events to the calendar.
Function displayCalendar($events : Collection)
	
	var $shape:=cs:C1710.VPShape.new(This:C1470._VPArea)
	var $column; $rowStart; $rowEnd : Integer
	var $myEvent : Object
	
	For each ($myEvent; $events)
		This:C1470._formatEvent($myEvent)
		
		$column:=Day number:C114($myEvent.start.date)
		
		If (Not:C34($myEvent.isAllDay))
			$rowStart:=This:C1470.searchRow($myEvent.start.time)
			$rowEnd:=This:C1470.searchRow($myEvent.end.time)
		Else 
			$rowStart:=This:C1470._allDayRow
			$rowEnd:=This:C1470._allDayRow+1
		End if 
		
		
		$shape.addFromRange($myEvent.id; $myEvent.label; VP Cells(This:C1470._VPArea; $column; $rowStart; 1; $rowEnd-$rowStart+1); $myEvent.category.textColor; $myEvent.category.backgroundColor)
	End for each 
	
	$shape.bringToFront("timerdot")
	$shape.bringToFront("timersolid")
	
	// Updates an existing event shape after an event has changed.
Function updateEvent($name : Text; $event : Object)
	var $shape:=cs:C1710.VPShape.new(This:C1470._VPArea)
	var $column; $rowStart; $rowEnd : Integer
	
	This:C1470._formatEvent($event)
	
	$column:=Day number:C114($event.start.date)
	
	If (Not:C34($event.isAllDay))
		$rowStart:=This:C1470.searchRow($event.start.time)
		$rowEnd:=This:C1470.searchRow($event.end.time)
	Else 
		$rowStart:=This:C1470._allDayRow
		$rowEnd:=This:C1470._allDayRow+1
	End if 
	
	$shape.update($name; $event.label; VP Cells(This:C1470._VPArea; $column; $rowStart; 1; $rowEnd-$rowStart+1); $event.category.textColor; $event.category.backgroundColor)
	
	// Removes an event shape from the calendar.
Function removeEvent($name : Text)
	
	var $shape:=cs:C1710.VPShape.new(This:C1470._VPArea)
	$shape.remove($name)
	
	// Initializes the week header, highlights today, and displays the current time.
Function initCalendar($VPArea : Text)
	
	var $period:=WeekDate()
	var $date:=Date:C102($period.start)
	
	var $data : Object
	$data:={sunday: Day of:C23($date)}
	$data.monday:=Day of:C23($date+1)
	$data.tuesday:=Day of:C23($date+2)
	$data.wednesday:=Day of:C23($date+3)
	$data.thursday:=Day of:C23($date+4)
	$data.friday:=Day of:C23($date+5)
	$data.saturday:=Day of:C23($date+6)
	
	Try
		VP SET DATA CONTEXT($VPArea; $data)
		This:C1470._currentDayColumn:=Day number:C114(Current date:C33)
		VP SET CELL STYLE(VP Cells(This:C1470._VPArea; This:C1470._currentDayColumn; 0; 1; (This:C1470._timeSlot.length+1)); {backColor: This:C1470._backColorCurrentDate; foreColor: This:C1470._foreColorCurrentDate})
		
		This:C1470.displayCurrentTime()
	Catch
		//fail on first run after restart!?
	End try
	
	// Displays the current-time indicator on the calendar.
Function displayCurrentTime
	var $timeUTC:=Current time:C178()
	var $row:=This:C1470.searchRow($timeUTC)
	
	var $cell:=VP Cells(This:C1470._VPArea; 1; $row; This:C1470._currentDayColumn-1; 1)
	
	cs:C1710.VPShape.new(This:C1470._VPArea).addLine("timerdot"; $cell; This:C1470._foreColorCurrentDate)
	cs:C1710.VPShape.new(This:C1470._VPArea).addLine("timersolid"; VP Cells(This:C1470._VPArea; This:C1470._currentDayColumn; $row; 1; 1); This:C1470._foreColorCurrentDate; 1)
	
	// Returns the row corresponding to a time value.
	// Algorithm: Binary search through 5-minute time slot intervals.
	// Finds the slot where currentTime falls between _timeSlot[$i] and _timeSlot[$i+1],
	// then offsets the result from the first calendar row index.
Function searchRow($currentTime : Time) : Integer
	
	var $i : Integer
	var $row:=This:C1470._firstCalendarRow
	
	// Iterate through time slots to find matching interval
	For ($i; 0; This:C1470._timeSlot.length-2)
		// Check if currentTime falls within this 5-minute interval
		If (This:C1470._timeSlot[$i]<=$currentTime) && ($currentTime<This:C1470._timeSlot[$i+1])
			// Offset row by the number of intervals from the start
			$row+=$i
			return $row
		End if 
	End for 
	
	// Default to first calendar row if time not found
	
	// Converts an Office 365 event into the format required by the calendar.
	// Algorithm: Transforms raw event data by extracting dates/times and matching category colors.
	// Builds display label with formatting: subject + times for timed events, subject-only for all-day.
Function _formatEvent($event : Object)
	var $categories:=cs:C1710.OfficeProvider.me.categoryColor()
	
	// Extract date and time components from ISO datetime strings
	$event.start.date:=Date:C102($event.start.dateTime)
	$event.start.time:=Time:C179($event.start.dateTime)
	$event.end.date:=Date:C102($event.end.dateTime)
	$event.end.time:=Time:C179($event.end.dateTime)
	
	// Match event category to color palette, or use defaults if no category assigned
	If (($event.categories#Null:C1517) && ($event.categories.length>0))
		// Find category color by matching display name with event's first category
		$event.category:=$categories.find(Formula:C1597($1.result:=($1.value.displayName=$2)); $event.categories[0])
	Else 
		// Apply default grayscale colors for uncategorized events
		$event.category:={backgroundColor: This:C1470._defaultBackColorDate; textColor: This:C1470._defaultForeColorDate}
	End if 
	
	// Format label: include time range for timed events, omit for all-day events
	If (Not:C34($event.isAllDay))
		// Format: "Subject\nHH:MM-HH:MM" (e.g., "Meeting\n14:30-15:30")
		$event.label:=String:C10($event.subject)+"\\n"+String:C10(Time:C179($event.start.time); HH MM:K7:2)+"-"+String:C10(Time:C179($event.end.time); HH MM:K7:2)
	Else 
		// All-day events display subject only
		$event.label:=String:C10($event.subject)
	End if 