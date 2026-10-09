If (FORM Event:C1606.code=On VP Ready:K2:59)
	
	Form:C1466.vpReady:=True:C214
	
	If (Form:C1466.calendar=Null:C1517)\
		 && (Form:C1466.officeCalendarNotifier#Null:C1517)\
		 && (Form:C1466.officeCalendarNotifier.isStarted)
		Form:C1466.calendar:=cs:C1710.Form_Calendar.new()
		OBJECT SET VISIBLE:C603(*; "ViewProArea"; True:C214)
	End if 
	
End if 