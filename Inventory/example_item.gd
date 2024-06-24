@tool
extends Node2D

@export var item_data :Item
@onready var sprite = $Sprite2D
var scene_path = "res://Inventory/example_item.tscn"


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Global.add_item_to_inventory(item_data)
	 # adds specific key pair into array
	#var inv = []
	#for i in range(Global.inventory.size()):
		#if Global.inventory[i] !=null:
			#inv.append(Global.inventory[i]["max_stack"])
	#print (inv)
