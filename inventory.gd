extends Control


@onready var inventory = preload("res://playerInventory.tres")
@onready var grid_container = $NinePatchRect/GridContainer


func _ready():
	Global.inventoryUpdate.connect(on_inventory_update)
	on_inventory_update()

func on_inventory_update():
	cleargrid()
	for item in Global.inventory:
		var slot = Global.slot_scene.instantiate()
		grid_container.add_child(slot)
		if item!=null:
			slot.set_item(item,item["quantity"])
		else:
			slot.set_empty()

func cleargrid():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
