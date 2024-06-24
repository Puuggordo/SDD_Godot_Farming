extends StaticBody2D

var coins = Global.player_funds
var carrot = Global.carrot_number
var onion = Global.onion_number
var strawberry = Global.strawberry_number
var corn = Global.corn_number
var apple = Global.apple_number
var orange = Global.orange_number
var lettuce = Global.lettuce_number

func _on_area_2d_body_entered(body):
	if body.has_method("get_input"):
		Global.player_funds += Global.carrot_number * 5
		Global.player_funds += Global.onion_number * 8
		Global.player_funds += Global.strawberry_number * 10
		Global.carrot_number = 0
		Global.onion_number = 0
		Global.strawberry_number = 0
