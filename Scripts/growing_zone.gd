extends Node2D

var plant
var flower_growing = false
var flower_grown = false
var previous_day = Global.current_day
var flower_alive = true
var item_data : Item
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
		print("max frames: ",max_frames)
		print("frame before: ",plant_growth_animator.frame)
		if flower_alive and max_frames != 0:
			plant_growth_animator.frame += 1
			print("frame after: ",plant_growth_animator.frame)
			if plant_growth_animator.frame == max_frames:
				flower_grown = true
				print("grown")

func _on_area_2d_area_entered(area):
	var item_object = area.get_parent()
	if "item_data" in item_object and !flower_growing and !flower_grown:
		item_data = item_object.item_data
		#print(plant_growth_animator.get_sprite_frames().get_animation_names())
		if item_data.type == "flower":
			plant_growth_animator.set_sprite_frames(item_data.growth_frames)
			plant_growth_animator.play("default")
			flower_growing = true
			flower_alive = true
		elif item_data.type == "fertiliser":
			pass


func flower_affinities_handler():
	var picker = randf()
	print("current weather: ",Global.current_weather)
	print(item_data)
	if str(Global.current_weather) != "none" and item_data != null:
		if item_data.strengths != [] or item_data.weaknesses != null:
			for strengths in item_data.strengths:
				if Global.current_weather == strengths and picker<=0.25:
					flower_alive = false
					print("strength, unalive")
					flower_exterminator()
					break
		elif item_data.weaknesses != [] or item_data.weaknesses != null:
			for weaknesses in item_data.weaknesses:
				if Global.current_weather == weaknesses and picker<=0.75:
					flower_alive = false
					print("weakness, unalive")
					flower_exterminator()
					break
		if picker <=0.5:
			flower_alive = false
			print("normal, unalive")
			flower_exterminator()
		else:
			flower_alive = true


func flower_resource():
	if item_data != null:
		var min_pollen = item_data.pollen_range_min
		var max_pollen = item_data.pollen_range_max
		var pollen_output = randi_range(min_pollen, max_pollen)
		Global.player_pollen += pollen_output
		print(Global.player_pollen)


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click") and flower_grown and !Global.mouse_in_use:
		flower_resource()
		flower_exterminator()

func flower_exterminator():
	flower_grown = false
	item_data = null
	flower_growing = false
	plant_growth_animator.set_sprite_frames(none_frame)
	plant_growth_animator.play("default")
