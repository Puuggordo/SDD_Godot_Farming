extends Node

var mouse_in_use = false
var current_weather = "none"
var current_day = 0
var player_funds = 100
var player_pollen =0
var quota = 0
var days_until_quota = 0


var inventory = []
signal inventoryUpdate
@onready var slot_scene = preload("res://Inventory/slot.tscn")
var current_drag_data = null
var cant_drop_data = false
var applicable_active_screen = true

var hotbar_selected_item
var hotbar_can_scroll = true

var shop_items = []

var weather_forcast = []

func array_checker(array: Array, value: String):
	var inv = []
	for r in range(array.size()):
		if array[r] !=null:
			inv.append(array[r][value])
	print(inv)

func _ready():
	inventory.resize(15)
	shop_items.resize(5)

func _process(delta):
	for i in range(inventory.size()):
		var slot = inventory[i]
		if slot!= null and slot.quantity <= 0:
			inventory.remove_at(i)
			inventory.insert(i,null)
			inventoryUpdate.emit()


func add_item_to_shop(item:Item):
	for i in range(shop_items.size()):
		var slot:Item = shop_items[i]
		if slot != null and slot.item_name == item.item_name:
			shop_items.remove_at(i)
			shop_items.insert(i,item)
			return
		elif slot == null:
			shop_items.remove_at(i)
			shop_items.insert(i,item)
			return
	return


func add_item_to_inventory(item: Item):
	# Loops through the inventory
	for i in range(inventory.size()):
		var slot = inventory[i]
		# If the items match
		if slot != null and slot.item_name == item.item_name:
			# And if the quantity is less than the max stack
			if slot.quantity + item.quantity <= item.max_stack:
				# then add the item quantities together
				slot.quantity += item.quantity
				# Send a singal to update the inventory
				inventoryUpdate.emit()
				return
			# If the quantity is over the max stack
			else:
				# Then take the remainder
				var space_left = item.max_stack - slot.quantity
				# Set the slot quantity to the max
				slot.quantity = item.max_stack
				item.quantity -= space_left
				# And add the remainder as a new item
				for r in range(inventory.size()):
					if slot == null:
						inventory.remove_at(r)
						inventory.insert(r,item)
						return
	for i in range(inventory.size()):
		var slot = inventory[i]
		# If there are no matches (if the current looped item is null)
		if slot == null:
			# Then set the new item as a new slot
			inventory.remove_at(i)
			inventory.insert(i,item)
			# Send a singal to update the inventory
			inventoryUpdate.emit()
			return
	return

func remove_item_from_inventory(item: Item):
	# Loops through the inventory
	for i in range(inventory.size()):
		var slot: Item = inventory[i]
		# If the items match
		if slot != null and slot.item_name == item.item_name:
			slot.quantity -= 1
			# Send a singal to update the inventory
			inventoryUpdate.emit()
			return
	return


func clear_grid(container):
	# While there are slots in the container
	while container.get_child_count() > 0:
		var child = container.get_child(0)
		# Delete the slot from existance >:(
		container.remove_child(child)
		child.queue_free()


func make_items_unique():
	# Goal is to make sure the item resources in each slot are unique, as data from same resources are shared
	var unique_items = []
	#loops through the inventory
	for item in inventory:
		#if there is an item
		if item != null:
			# Duplicate the item (making it unique) and add the unique item to the inventory with unique items
			unique_items.append(item.duplicate())
		# If there is no item
		else:
			# Add an empty slot into the inventory with unique items
			unique_items.append(null)
	# Set the inventory into inventory with unique items
	inventory = unique_items
