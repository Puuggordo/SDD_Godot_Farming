extends CanvasLayer


func _process(_delta):
	%CoinLabel.text = "= " + str(Global.player_funds)
	%PollenLabel.text = "= " + str(Global.player_pollen)
