@tool
extends Node2D

@export var quantity:int
@export var item_type = ""
@export var item_name = ""
@export var description = ""
@export var max_stack = 5
@export var item_texture : Texture2D = null
@onready var sprite = $Sprite2D
var scene_path = "res://Inventory/example_item.tscn"

func _ready():
	if not Engine.is_editor_hint():
		sprite.texture = item_texture

func _process(delta):
	if Engine.is_editor_hint():
		sprite.texture = item_texture

func pickup_item():
	var item = {
		"quantity":quantity,
		"type":item_type,
		"name":item_name,
		"texture":item_texture,
		"scene_path":scene_path,
		"max_stack":max_stack
	}
	Global.add_item(item)


func _on_area_2d_body_entered(body):
	if body.has_method("animator"):
		pickup_item()
		print(Global.inventory)
