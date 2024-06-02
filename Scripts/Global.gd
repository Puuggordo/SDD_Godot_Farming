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
		if slot!= null and slot["name"] == item["name"]:
			slot["quantity"] += item["quantity"]
			inventoryUpdate.emit()
			return true
		elif slot == null:
			inventory.remove_at(i)
			inventory.insert(i,item)
			inventoryUpdate.emit()
			return true
	return false


func remove_item(item, count) -> bool:
	for slot in inventory:
		if slot["item"] == item:
			if slot["count"] >= count:
				slot["count"] -= count
				if slot["count"] == 0:
					slot["item"] = null
				return true
			else:
				count -= slot["count"]
				slot["item"] = null
				slot["count"] = 0
	return count == 0


var item = {
	0 : {
		"Name" : "Strawberry seed",
		"Cost" : 100,
	},
	1 : {
		"Name" : "Lettuce seed",
		"Cost" : 500
	},
	2 : {
		"Name" : "Corn seed",
		"Cost" : 1000
	}
}
