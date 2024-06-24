extends Node

var plant_selected
var current_weather = "none"
var current_day = 0
var player_funds = 1000
var carrot_number = 0
var onion_number = 0
var strawberry_number = 0
var corn_number = 0 
var lettuce_number = 0
var apple_number = 0
var orange_number = 0

var strawberry_buy = false
var corn_buy = false
var lettuce_buy = false

var inventory = []
signal inventoryUpdate
@onready var slot_scene = preload("res://slot.tscn")
var current_drag_data = null
var cant_drop_data = false

var shop_items = []

func array_checker(array: Array, value: String):
	var inv = []
	for r in range(array.size()):
		if array[r] !=null:
			inv.append(array[r][value])
	print(inv)

func _ready():
	inventory.resize(15)
	shop_items.resize(3)

func add_item_to_shop(item):
	for i in range(shop_items.size()):
		var slot = shop_items[i]
		if slot != null and slot["name"] == item["name"]:
			shop_items.remove_at(i)
			shop_items.insert(i,item)
			return
		elif slot == null:
			shop_items.remove_at(i)
			shop_items.insert(i,item)
			return
	return


func add_item_to_inventory(item: Item):
	#loops through the inventory
	for i in range(inventory.size()):
		var slot = inventory[i]
		#if the items match
		if slot != null and slot.item_name == item.item_name:
			#and if the quantity is less than the max stack
			if slot.quantity + item.quantity <= item.max_stack:
				#then add the item quantities together
				slot.quantity += item.quantity
				inventoryUpdate.emit()
				return
			#if the quantity is over the max stack
			else:
				#then take the remainder
				var space_left = item.max_stack - slot.quantity
				#set the slot quantity to the max
				slot.quantity = item.max_stack
				item.quantity -= space_left
				#and add the remainder as a new item
				for r in range(inventory.size()):
					if slot == null:
						inventory.remove_at(r)
						inventory.insert(r,item)
						return
	for i in range(inventory.size()):
		var slot = inventory[i]
		#if there are no matches (if the current looped item is null)
		if slot == null:
			#then set the new item as a new slot
			inventory.remove_at(i)
			inventory.insert(i,item)
			inventoryUpdate.emit()
			return
	return

func remove_item_from_inventory(item: Item):
	#loops through the inventory
	for i in range(inventory.size()):
		var slot: Item = inventory[i]
		#if the items match
		if slot != null and slot.item_name == item.item_name:
			slot.quantity -= 1
			if slot.quantity <= 0:
				slot = null
			inventoryUpdate.emit()
			return
	return

func swap_items(item_index, target_item_index):
	var target_item = inventory[target_item_index]
	var item = inventory[item_index]
	inventory[target_item_index] = item
	inventory[item_index] = target_item
	inventoryUpdate.emit()

func apply_effect(effect):
	pass
