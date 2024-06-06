extends Node

var plant_selected
var coin_number = 0
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

func _ready():
	inventory.resize(15)


func add_item(item):
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

var shop_items = {
	0 : {
		"Name": "Strawberry seed",
		"Cost": 100,
	},
	1 : {
		"Name": "Lettuce seed",
		"Cost": 500
	},
	2 : {
		"Name": "Corn seed",
		"Cost": 1000
	}
}
