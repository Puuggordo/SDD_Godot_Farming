extends CanvasLayer

@onready var inventory = $Inventory

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused
