If (FORM Event:C1606.code=On VP Ready:K2:59)
	
	If (Form:C1466.calendar=Null:C1517)
		Form:C1466.calendar:=cs:C1710.Form_Calendar.new()
	End if 
	
End if 