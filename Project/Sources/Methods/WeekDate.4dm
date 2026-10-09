//%attributes = {"invisible":true}
#DECLARE : Object

// Get today's date
var $week:=cs:C1710.DateTimeUtils.DateTime.new().startAndEndOfWeek

var $result:={start: $week.start.toUTC(); end: $week.end.toUTC()}

return $result