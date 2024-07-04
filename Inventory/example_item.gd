@tool
extends Node2D

@export var item_data :Item
@onready var sprite = $Sprite2D
var selected = false
var scene_path = "res://Inventory/example_item.tscn"

func _ready():
	sprite.texture = item_data.item_texture

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Global.add_item_to_inventory(item_data)


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true


func _physics_process(delta):
	if selected:
		global_position = global_position.lerp(get_global_mouse_position(),15 * delta)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			selected = false
