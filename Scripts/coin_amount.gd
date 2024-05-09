extends HBoxContainer


func _process(_delta):
	$Label.text = "= " + str(Global.coin_number)
