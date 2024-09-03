extends CanvasLayer


func _process(delta):
	$Label.text = "You survived "+str(Global.current_day)+" days"
