extends HBoxContainer


func _process(_delta):
	$Label.text = "= " + str(Global.player_funds)
