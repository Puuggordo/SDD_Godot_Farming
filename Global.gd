extends Node

var mouse_in_use = false
var current_weather = "none"
var current_day = 0
var player_funds = 1000000
var player_pollen = 0
var quota = 0
var days_until_quota = 0
var times_quota_fulfilled = 0
var starting_quota = 100
var deadline = 14

var inventory = []
signal inventoryUpdate
@onready var slot_scene = preload("res://inventory/slot.tscn")
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
	shop_items.resize(7)
	# Set the number of days remaining to meet the quota
	days_until_quota = deadline
	# Set the initial quota value
	quota = starting_quota


func _process(delta):
	# Loop through each slot in the inventory to check for items with zero or negative quantity
	for i in range(inventory.size()):
		var slot = inventory[i]
		# If the slot is not empty and the item quantity is zero or less
		if slot != null and slot.quantity <= 0:
			# Remove the item from the inventory
			inventory.remove_at(i)
			# Insert a null value in its place to maintain inventory size
			inventory.insert(i, null)
			# Emit a signal to indicate the inventory has been updated
			inventoryUpdate.emit()
	# Ensure the player funds don't fall below zero
	if player_funds < 0:
		player_funds = 0
	# Call a function to calculate and update the quota based on the current state
	calculate_quota()


func add_item_to_shop(item: Item):
	# Loop through each slot in the shop inventory to find a place to add or replace the item
	for i in range(shop_items.size()):
		var slot: Item = shop_items[i]
		# Check if the slot is not empty and the item in the slot matches the item to be added
		if slot != null and slot.item_name == item.item_name:
			# If a matching item is found, remove the current item in the slot
			shop_items.remove_at(i)
			# Insert the new item in the same slot, replacing the old one
			shop_items.insert(i, item)
			# Exit the function as the item has been successfully replaced
			return
		# Check if the slot is empty
		elif slot == null:
			# If the slot is empty, remove it
			shop_items.remove_at(i)
			# Insert the new item in the empty slot
			shop_items.insert(i, item)
			# Exit the function as the item has been successfully added
			return
	# If the function reaches this point, no further action is needed as the item has been added or replaced
	return


func add_item_to_inventory(item: Item):
	# Item is the item being added 
	# Loop through each slot in the inventory
	for i in range(inventory.size()):
		var slot = inventory[i]
		# Check if the slot is not null and the item in the slot matches the item to be added
		# Attempts to merge the item with existing items in the inventory
		if slot != null and slot.item_name == item.item_name:
			# Check if adding the item quantity does not exceed the maximum stack limit
			if slot.quantity + item.quantity <= item.max_stack:
				# Combine the quantities of the existing item and the new item
				slot.quantity += item.quantity
				# Emit a signal to indicate the inventory has been updated
				inventoryUpdate.emit()
				# Exit the function as the item quantity is less than max stack
				return
			# If the quantity is over the max stack
			elif slot.quantity + item.quantity > item.max_stack:
				# Total quantity being in the inventory 
				var total = slot.quantity + item.quantity
				# Set the slot quantity to the max
				slot.quantity = item.max_stack
				# Set the item quantity (item thats being added) equal to the total - max stack
				# Adjust the item's quantity to the remaining amount that couldn't fit in the slot
				item.quantity = total - item.max_stack
				# Loops until a return function (i.e. if the item quantity is less than the max stack)
				# Continue looping to place the remaining quantity in another slot
				continue
		# If the slot is empty (i.e. there is no unfilled slots for the item to be placed in)
		elif slot == null:
			# If the item quantity exceeds the max stack
			if item.quantity > item.max_stack:
				# Remove the empty slot and insert the item
				inventory.remove_at(i)
				inventory.insert(i, item)
				inventoryUpdate.emit()
				# Adjust the slot quantity to the maximum stack limit
				slot = Global.inventory[i]
				slot.quantity = item.max_stack
				# Reduce the item's quantity by the amount placed in this slot
				item.quantity = item.quantity - item.max_stack
				inventoryUpdate.emit()
				# Loops until a return function (i.e. if the item quantity is less than the max stack)
				# Continue looping to place the remaining quantity in another slot
				continue
			# If the new item quantity is less than or equal to the max stack
			elif item.quantity <= item.max_stack:
				# Insert the new item into the empty slot
				inventory.remove_at(i)
				inventory.insert(i, item)
				# Emit a signal to indicate the inventory has been updated
				inventoryUpdate.emit()
				# Exit the function as the item quantity is less than max stack
				return
	# If the function reaches this point, no suitable slot was found (i.e. inventory is full), so no further action is taken
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
	if days_until_quota == -1:
		times_quota_fulfilled += 1
		days_until_quota = deadline
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
