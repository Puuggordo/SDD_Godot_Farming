extends Node2D

var plant
var plant_growing = false
var plant_grown = false
var previous_day = Global.current_day
@onready var plant_growth_animator = $plant_growing


func _ready():
	plant_growth_animator.play("none")


func _process(delta):
	if Global.current_day == previous_day + 1:
		previous_day = Global.current_day
		var max_frames = plant_growth_animator.get_sprite_frames().get_frame_count("default")
		if plant_growth_animator.frame == -1:
			print("max growth")
		else:
			plant_growth_animator.frame += 1


func _physics_process(_delta):
	if plant_growing == false:
		plant = Global.plant_selected


func _on_area_2d_area_entered(area):
	var item_object = area.get_parent()
	if "item_data" in item_object:
		var item_data : Item = item_object.item_data
		#print(plant_growth_animator.get_sprite_frames().get_animation_names())
		plant_growth_animator.set_sprite_frames(item_data.growth_frames)
		plant_growth_animator.play("default")


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		pass

