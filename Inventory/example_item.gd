@tool
extends Node2D

@export var item_data :Item
@onready var sprite = $Sprite2D
var scene_path = "res://Inventory/example_item.tscn"


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Global.add_item_to_inventory(item_data)
