extends Node2D


func _on_shop_area_body_entered(body):
	# Show the shop UI when the player enters the shop area.
	if body.name == "Player":
		$shop.show()
		Global.applicable_active_screen = false

func _on_shop_area_body_exited(_body):
	# Hide the shop UI when the player exits the shop area.
	$shop.hide()
	Global.applicable_active_screen = true


func _input(event):
	# Toggle the visibility of the inventory and hotbar UI when the "toggle_inventory" action is pressed.
	if event.is_action_pressed("toggle_inventory") and Global.applicable_active_screen:
		$inventory_ui.visible = !$inventory_ui.visible
		$UI/Hotbar.visible = !$UI/Hotbar.visible
		# Pause the game when the inventory is toggled.
		get_tree().paused = true
