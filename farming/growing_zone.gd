extends Node2D

var flower_growing = false
var flower_grown = false
var previous_day = Global.current_day
var flower_alive = true
var fertilised = false
var item_data : Item
var flower : Item
var fertiliser : Item
var growth_multiplier = 1
var pollen_multiplier = 1
@export var none_frame: SpriteFrames
@onready var plant_growth_animator = $plant_growing
@onready var particle = $fertiliser_sprite


var node_size = Vector2(16,16)
var mouse_button_held = false


func _ready():
	# Set the plant growth animation to "none" initially
	plant_growth_animator.play("none")

func _process(delta):
	# Check if a new day has started
	if Global.current_day == previous_day + 1:
		previous_day = Global.current_day
		
		# Handle flower growth and affinities if conditions are met
		if item_data != null and flower_alive and !flower_grown:
			flower_affinities_handler()
		
		# Determine the maximum frames for the plant growth animation
		var max_frames = plant_growth_animator.get_sprite_frames().get_frame_count("default") - 1
		
		# Increment the growth animation frame if the flower is alive and not fully grown
		if flower_alive and max_frames != 0:
			plant_growth_animator.frame += 1 * growth_multiplier
			# Mark the flower as fully grown if the last frame is reached
			if plant_growth_animator.frame == max_frames:
				flower_grown = true
	
	# Handle planting and fertilizing when the mouse button is held and an item is selected from the hotbar
	if mouse_button_held and Global.hotbar_selected_item != null:
		# Get the mouse position in global coordinates
		var mouse_pos = get_global_mouse_position()
		# Check if the mouse is over this specific soil plot
		if is_mouse_over_soil(mouse_pos):
			item_data = Global.hotbar_selected_item
			# Plant a flower if conditions are met
			if item_data.type == "flower" and !flower_growing and !flower_grown:
				Global.remove_item_from_inventory(item_data)
				flower = item_data
				plant_growth_animator.set_sprite_frames(item_data.growth_frames)
				plant_growth_animator.speed_scale = 0
				plant_growth_animator.play("default")
				flower_growing = true
				flower_alive = true
				fertilised = false
			# Apply fertiliser effects if fertiliser is selected
			elif item_data.type == "fertiliser" and !fertilised:
				fertiliser = item_data
				if flower != null:
					fertilised = true
					Global.remove_item_from_inventory(item_data)
					apply_fertiliser_effect()


func _input(event):
	# Detect if the left mouse button is pressed or released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_button_held = event.pressed


func is_mouse_over_soil(mouse_pos: Vector2) -> bool:
	# Determine if the mouse is currently over the soil plot
	var soil_rect = Rect2(global_position, node_size)
	return soil_rect.has_point(mouse_pos)


func flower_affinities_handler():
	# Randomly determine if the current weather affects the flower
	var picker = randf()
	# Check if the current weather matches any of the flower's strengths
	for strengths in flower.strengths:
		# 10% for the flower to die
		if Global.current_weather == strengths and picker <= 0.1:
			flower_exterminator()
			return
	# Check if the current weather matches any of the flower's weaknesses
	for weaknesses in flower.weaknesses:
		# 50% for the flower to die
		if Global.current_weather == weaknesses and picker <= 0.5:
			flower_exterminator()
			return
	# If there is no weather
	if Global.current_weather == "none":
		# The flower remains alive
		flower_alive = true
		return
	# If no strengths or weaknesses match, there is a 20% for the flower to die
	elif picker <=0.2:
		flower_exterminator()
		return


func flower_resource():
	# Calculate and add pollen to the player's resources when the flower is harvested
	if flower != null:
		var min_pollen = round(flower.pollen_range_min * pollen_multiplier)
		var max_pollen = round(flower.pollen_range_max * pollen_multiplier)
		var pollen_output = randi_range(min_pollen, max_pollen)
		Global.player_pollen += pollen_output

# Apply fertiliser effects on growth and pollen production
func apply_fertiliser_effect():
	# Pick a number between 0 and 1
	var picker = randf()
	# Check if the random number is less than or equal to the fractional part of the fertiliser's growth effect
	if picker <= (fertiliser.effect_growth - int(fertiliser.effect_growth)):
		# If true, increase the growth multiplier by 1
		growth_multiplier = int(fertiliser.effect_growth) + 1
	# Otherwise, use the integer part of the growth effect as the multiplier
	else:
		growth_multiplier = int(fertiliser.effect_growth)
	# Apply the pollen multiplier if the fertiliser effect is greater than 1
	if fertiliser.effect_pollen > 1:
		pollen_multiplier = fertiliser.effect_pollen
	else: 
		pollen_multiplier = 1
	# Show fertiliser particle effects for a brief duration
	particle.show()
	await get_tree().create_timer(.5).timeout
	particle.hide()
	fertilised = true


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	# Handle player input for harvesting the flower when it's grown
	if Input.is_action_pressed("click") and flower_grown:
		flower_resource()
		flower_exterminator()


func flower_exterminator():
	# Reset flower-related variables when the flower is removed
	flower = null
	flower_grown = false
	flower_growing = false
	flower_alive = false
	fertilised = false
	# Reset the plant growth animator to its default state
	plant_growth_animator.set_sprite_frames(none_frame)
	plant_growth_animator.play("default")
	# Reset multipliers to their default values
	pollen_multiplier = 1
	growth_multiplier = 1
