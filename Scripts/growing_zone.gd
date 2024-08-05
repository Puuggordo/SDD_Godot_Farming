extends Node2D

var flower_growing = false
var flower_grown = false
var previous_day = Global.current_day
var flower_alive = true
var item_data : Item
var flower : Item
var fertiliser : Item
var growth_multiplier = 1
var pollen_multiplier = 1
@export var none_frame: SpriteFrames
@onready var plant_growth_animator = $plant_growing


func _ready():
	plant_growth_animator.play("none")


func _process(delta):
	if Global.current_day == previous_day + 1:
		previous_day = Global.current_day
		if item_data != null and flower_alive and !flower_grown:
			flower_affinities_handler()
		var max_frames = plant_growth_animator.get_sprite_frames().get_frame_count("default")-1
		#print("max frames: ",max_frames)
		#print("frame before: ",plant_growth_animator.frame)
		if flower_alive and max_frames != 0:
			plant_growth_animator.frame += 1*(growth_multiplier)
			#print("frame after: ",plant_growth_animator.frame)
			if plant_growth_animator.frame == max_frames:
				flower_grown = true


func _on_area_2d_area_entered(area):
	var item_object = area.get_parent()
	if "item_data" in item_object:
		var item_data = item_object.item_data
		#print(plant_growth_animator.get_sprite_frames().get_animation_names())
		print(item_data.type)
		if item_data.type == "flower"  and !flower_growing and !flower_grown:
			flower = item_data
			plant_growth_animator.set_sprite_frames(item_data.growth_frames)
			plant_growth_animator.play("default")
			flower_growing = true
			flower_alive = true
		elif item_data.type == "fertiliser":
			fertiliser = item_data
			if flower != null:
				apply_fertiliser_effect()


func flower_affinities_handler():
	var picker = randf()
	for strengths in flower.strengths:
		if Global.current_weather == strengths and picker<=0.1:
			flower_exterminator()
			return
	for weaknesses in flower.weaknesses:
		if Global.current_weather == weaknesses and picker<=0.5:
			flower_exterminator()
			return
	if picker <=0.2:
		flower_exterminator()
		return
	else:
		flower_alive = true
		return


func flower_resource():
	if flower != null:
		var min_pollen = round(flower.pollen_range_min * pollen_multiplier)
		var max_pollen = round(flower.pollen_range_max * pollen_multiplier)
		var pollen_output = randi_range(min_pollen, max_pollen)
		print(pollen_output)
		Global.player_pollen += pollen_output

func apply_fertiliser_effect():
	var picker = randf()
	if picker <= (fertiliser.effect_growth - int(fertiliser.effect_growth)):
		growth_multiplier = int(fertiliser.effect_growth)+1
	else:
		growth_multiplier = int(fertiliser.effect_growth)
	if fertiliser.effect_pollen > 1:
		pollen_multiplier = fertiliser.effect_pollen
	else: 
		pollen_multiplier = 1
	#fertiliser.effect_remove_weaknesses
	#fertiliser.effect_add_strengths


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click") and flower_grown and !Global.mouse_in_use:
		flower_resource()
		flower_exterminator()


func flower_exterminator():
	flower = null
	flower_grown = false
	flower_growing = false
	flower_alive = false
	plant_growth_animator.set_sprite_frames(none_frame)
	plant_growth_animator.play("default")
	pollen_multiplier = 1
	growth_multiplier = 1
