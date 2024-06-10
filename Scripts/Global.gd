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
			return true
		elif slot == null:
			shop_items.remove_at(i)
			shop_items.insert(i,item)
			return true
	return false


func add_item_to_inventory(item):
	for i in range(inventory.size()):
		var slot = inventory[i]
		if slot != null and slot["name"] == item["name"]:
			if slot["quantity"] + item["quantity"] <= item["max_stack"]:
				slot["quantity"] += item["quantity"]
				inventoryUpdate.emit()
				return true
			else:
				var space_left = item["max_stack"] - slot["quantity"]
				slot["quantity"] = item["max_stack"]
				item["quantity"] -= space_left
				for r in range(inventory.size()):
					if slot == null:
						inventory.remove_at(r)
						inventory.insert(r,item)
						return true
		elif slot == null:
			inventory.remove_at(i)
			inventory.insert(i,item)
			inventoryUpdate.emit()
			return true
	return false

func apply_effect(effect):
	
