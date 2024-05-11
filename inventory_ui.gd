extends CanvasLayer

@onready var inventory = $Inventory

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()


func _on_inventory_closed():
	get_tree().paused = false


func _on_inventory_opened():
	get_tree().paused = true
