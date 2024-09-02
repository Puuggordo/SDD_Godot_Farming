extends Node

var mouse_in_use = false
var current_weather = "none"
var current_day = 0
var player_funds = 10000
var player_pollen = 0
var quota = 0
var days_until_quota = 0
var times_quota_fulfilled = 0


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
	if player_funds < 0:
		player_funds = 0
	calculate_quota()


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
	# Loop through each slot in the inventory to attempt to merge the item with existing inventory slots
	for i in range(inventory.size()):
		var slot = inventory[i]
		# Check if the slot is not null and the item in the slot matches the item to be added
		if slot != null and slot.item_name == item.item_name:
			# Check if adding the item quantity does not exceed the maximum stack limit
			if slot.quantity + item.quantity <= item.max_stack:
				if slot != null:
					print("not over stack")
					print(slot.item_name)
					print(item.item_name)
				# Combine the quantities of the existing item and the new item
				slot.quantity += item.quantity
				# Emit a signal to indicate the inventory has been updated
				inventoryUpdate.emit()
				return
			# If the quantity is over the max stack
			if slot.quantity + item.quantity > item.max_stack:
				if slot != null:
					print("if over stack")
					print(slot.item_name)
					print(item.item_name)
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
				# Handle overflow situation by splitting items into new slots
				slot_overflow(slot, item)
	# Loop through the inventory again to find an empty slot for the new item (if there was no item in the inventory)
	for i in range(inventory.size()):
		var slot = inventory[i]
		# Check if the current slot is null (empty)
		if slot == null:
			# If the item quantity exceeds the max stack, handle the overflow
			if item.quantity > item.max_stack:
				slot_overflow(slot, item)
			else: # If the new item quantity is less than or equal to the max stack
				# Insert the new item into the empty slot
				inventory.remove_at(i)
				inventory.insert(i, item)
				# Emit a signal to indicate the inventory has been updated
				inventoryUpdate.emit()
				return
	return

func slot_overflow(slot, item):
	# Create new slots for the remaining quantity of the item
	while item.quantity > 0:
		# Try to find an empty slot in the inventory
		for j in range(inventory.size()):
			if inventory[j] == null:
				# Add the remaining item to the empty slot
				inventory[j] = item.duplicate()
				inventory[j].quantity = min(item.quantity, item.max_stack)
				item.quantity -= inventory[j].quantity
				break
		# Exit the loop if there's no remaining quantity
		if item.quantity <= 0:
			break
	inventoryUpdate.emit()  # Notify that the inventory has been updated
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
	# Loops through the inventory
	for item in inventory:
		# If there is an item
		if item != null:
			# Duplicate the item (making it unique) and add the unique item to the inventory with unique items
			unique_items.append(item.duplicate())
		# If there is no item
		else:
			# Add an empty slot into the inventory with unique items
			unique_items.append(null)
	# Set the inventory into inventory with unique items
	inventory = unique_items

func calculate_quota():
	if current_day == 0:
		days_until_quota = 14
		quota = 100
	if days_until_quota == 0:
		times_quota_fulfilled += 1
		days_until_quota = 14
		# Generate a normally-distributed random number with a mean of 0.5 and a deviation of 0.095.
		# Adding 1 to shift the range of the generated number to be around 1 instead of 0.5.
		var randomfn = randfn(0.5, 0.095) + 1
		# Calculate the quota incrementer based on the number of times the quota has been fulfilled.
		# This uses an exponential growth pattern, where the incrementer increases faster as 'times_quota_fulfilled' grows. 
		# The exponent of 2 ensures the quota increases at a controlled exponential rate.
		var quota_incrementer = (1 + times_quota_fulfilled**2)
		# Calculate the new quota by multiplying a base quota (100) by the quota incrementer
		# and the randomly generated multiplier (randomfn). The result is then converted to an integer.
		quota = int(100 * quota_incrementer * randomfn)
