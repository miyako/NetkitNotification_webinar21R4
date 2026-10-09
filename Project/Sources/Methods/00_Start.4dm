//%attributes = {}
#DECLARE($params : Object)

var $windowTitle : Text
$windowTitle:=Localized string("Notifications_WindowTitle")

var $window : Integer

If (Count parameters:C259=0)
	
	ARRAY LONGINT($windows; 0)
	WINDOW LIST($windows)
	
	var $i : Integer
	For ($i; 1; Size of array($windows))
		$window:=$windows{$i}
		If (Window process($window)=1) && (Get window title($window)=$windowTitle)
			var $x; $y; $bottom; $right : Integer
			GET WINDOW RECT($x; $y; $bottom; $right; $window)
			CALL FORM($window; Formula:C1597(SET WINDOW RECT($x; $y; $bottom; $right; $window)))
			return 
		End if 
	End for 
	
	CALL WORKER(1; Current method name; New object:C1471)
	
Else 
	
	SET MENU BAR(1)
	
	$window:=Open form window:C675("Notifications"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)
	SET WINDOW TITLE($windowTitle; $window)
	DIALOG:C40("Notifications"; *)
	
End if 
