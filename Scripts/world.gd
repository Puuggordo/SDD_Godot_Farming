extends Node2D


func _ready():
	$shop.hide()


func _on_shop_area_body_entered(body):
	if body.name == "Player":
		$shop.show()


func _on_shop_area_body_exited(_body):
	$shop.hide()


func _on_nextday_button_pressed():
	Global.current_day += 1
