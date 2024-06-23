extends Control


@onready var inventory = preload("res://playerInventory.tres")
@onready var grid_container = $NinePatchRect/GridContainer


func _ready():
	Global.inventoryUpdate.connect(on_inventory_update)
	on_inventory_update()
	
func on_inventory_update():
	clear_grid()
	for item in Global.inventory:
		var slot = Global.slot_scene.instantiate()
		grid_container.add_child(slot)
		if item!=null:
			slot.set_item(item,item.quantity)
		else:
			slot.set_empty()
	make_items_unique()

func clear_grid():
	#while there are slots in the grid container
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		#delete the slot from existance >:(
		grid_container.remove_child(child)
		child.queue_free()

func make_items_unique():
	#goal is to make sure the item resources in each slot are unique, as data from same resources are shared
	var unique_items = []
	#loops through the inventory
	for item in Global.inventory:
		#if there is an item
		if item != null:
			#duplicate the item (making it unique) and add the unique item to the inventory with unique items
			unique_items.append(item.duplicate())
		#if there is no item
		else:
			#add an empty slot into the inventory with unique items
			unique_items.append(null)
	#set the inventory into inventory with unique items
	Global.inventory = unique_items
