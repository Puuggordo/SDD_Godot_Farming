extends Control


@onready var inventory = preload("res://playerInventory.tres")
@onready var gridContainer = $NinePatchRect/GridContainer


func _ready():
	Global.inventoryUpdate.connect(on_inventory_update)
	on_inventory_update()

func on_inventory_update():
	cleargrid()
	for item in Global.inventory:
		var slot = Global.slot_scene.instantiate()
		gridContainer.add_child(slot)
		if item!=null:
			slot.set_item(item,item["quantity"])
		else:
			slot.set_empty()

func cleargrid():
	while gridContainer.get_child_count() > 0:
		var child = gridContainer.get_child(0)
		gridContainer.remove_child(child)
		child.queue_free()
