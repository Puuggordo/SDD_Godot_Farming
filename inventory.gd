extends Control


@onready var inventory = preload("res://playerInventory.tres")
@onready var grid_container = $NinePatchRect/GridContainer


func _ready():
	Global.inventoryUpdate.connect(on_inventory_update)
	on_inventory_update()

# When the singal to update the inventory is received 
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
	# While there are slots in the grid container
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		# Delete the slot from existance >:(
		grid_container.remove_child(child)
		child.queue_free()


func make_items_unique():
	# Goal is to make sure the item resources in each slot are unique, as data from same resources are shared
	var unique_items = []
	#loops through the inventory
	for item in Global.inventory:
		#if there is an item
		if item != null:
			# Duplicate the item (making it unique) and add the unique item to the inventory with unique items
			unique_items.append(item.duplicate())
		# If there is no item
		else:
			# Add an empty slot into the inventory with unique items
			unique_items.append(null)
	# Set the inventory into inventory with unique items
	Global.inventory = unique_items
