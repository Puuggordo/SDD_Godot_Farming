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
	if "item_data" in item_object and !plant_growing:
		var item_data : Item = item_object.item_data
		#print(plant_growth_animator.get_sprite_frames().get_animation_names())
		if item_data.type == "flower":
			plant_growth_animator.set_sprite_frames(item_data.growth_frames)
			plant_growth_animator.play("default")
			plant_growing = true
		elif item_data.type == "fertiliser":
			pass


func flower_affinities_handler():
	var picker = randf()
	if Global.current_weather != "none":
		for strengths in strengths_array:
			if Global.current_weather == strengths and picker<=0.25:
				flower_alive = false
				break
			else:
				break
		for weaknesses in weaknesses_array:
			if Global.current_weather == weaknesses and picker<=0.75:
				flower_alive = false
				break
			else:
				break
		if picker <=0.5:
			flower_alive = false
		else:
			flower_alive = true

func flower_growth():
	growth_state
	fully_grown
	max_growth
	if Global.next_day:
		growth_state +=1
	if growth_state == max_growth:
		fully_grown = true	

	sprite.play(growth_state)


func flower_resource():
	if fully_grown:
		min_pollen = flower_properties[pollen_range_min]
		max_pollen = flower_properties[pollen_range_max]
		pollen_output = randi_range(min_pollen, max_pollen)
		Global.player_pollen += pollen_output


func _process(delta):
	flower_affinities_handler()
	if flower_alive:
		flower_growth()

func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		pass

