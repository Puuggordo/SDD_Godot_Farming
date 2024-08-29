extends Node

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		$"../inventory_ui".visible = !$"../inventory_ui".visible
		$"../UI/Hotbar".visible = !$"../UI/Hotbar".visible
		get_tree().paused = false
		get_viewport().set_input_as_handled()
