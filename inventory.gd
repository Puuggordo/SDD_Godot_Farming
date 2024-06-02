extends Control


@onready var inventory = preload("res://playerInventory.tres")
@onready var slots = $NinePatchRect/GridContainer.get_children()


func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		on_inventory_update()


func on_inventory_update():
	for item in Global.inventory:
		var slot = Global.slot_scene.instantiate()
		if item !=null:
			slots.set_item(item,1)
func cleargrid():
	pass
