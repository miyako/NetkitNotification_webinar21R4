If (SignIn("Microsoft"))
	
	If (Form:C1466.officeMailNotifier=Null:C1517)
		// Create a new Microsoft 365 provider instance.
		var $office365:=cs:C1710.NetKit.Office365.new(cs:C1710.OfficeProvider.me.OAuth2)
		
		// Create a notification listener instance.
		var $NotificationMail:=cs:C1710.NotificationMail.new($office365)
		
		// Create and start a mail notifier.
		// The notifier subscribes to mail changes and automatically
		// invokes the listener callbacks when emails are created,modified or deleted.
		Form:C1466.officeMailNotifier:=$office365.mail.notifier($NotificationMail)
	End if 
	
	If (Not:C34(Form:C1466.officeMailNotifier.isStarted))
		Form:C1466.officeMailNotifier.start()
	End if 
	
	If (Form:C1466.officeCalendarNotifier=Null:C1517)
		// Create a notification listener instance.
		var $NotificationCalendar:=cs:C1710.NotificationCalendar.new($office365)
		// Create and start a calendar notifier.
		// The notifier subscribes to calendar event changes and
		// automatically invokes the listener callbacks when events are created, modified or deleted.
		Form:C1466.officeCalendarNotifier:=$office365.calendar.notifier($NotificationCalendar)
	End if 
	
	If (Not:C34(Form:C1466.officeCalendarNotifier.isStarted))
		Form:C1466.officeCalendarNotifier.start()
	End if 
	
End if 
