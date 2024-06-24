extends CanvasLayer

@onready var inventory = $Inventory

func _ready():
	self.hide()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused

