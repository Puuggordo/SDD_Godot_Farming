extends Node2D


func _ready():
	$shop.hide()


func _on_shop_area_body_entered(body):
	if body.name == "Player":
		$shop.show()


func _on_shop_area_body_exited(body):
	$shop.hide()
