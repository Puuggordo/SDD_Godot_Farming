extends CanvasLayer


func _process(_delta):
	%CoinLabel.text = "Honey = " + str(Global.player_funds)
	%PollenLabel.text = "Pollen = " + str(Global.player_pollen)
