extends Node2D

var difficulty
var weather_list = ["rain", "wind", "heat", "drought", "snow"]
var early_game = [0.3, 0.1, 0.1, 0.1, 0]
var mid_game = [0.1, 0.2, 0.15, 0.15, 0.1]
var end_game = [0, 0.1, 0.1, 0.2, 0.3]
var paused = false


# Function to determine the game's difficulty based on the current day.
func difficulty_scaler(day):
	if day <= 7:
		# Return the early game difficulty settings for days 1 through 7.
		difficulty = "early_game"
		return early_game
	elif day <= 14:
		# Return the mid game difficulty settings for days 8 through 14.
		difficulty = "mid_game"
		return mid_game
	else:
		# Return the end game difficulty settings for days 15 and beyond.
		difficulty = "end_game"
		return end_game

# Function to pick a weather type based on weighted probabilities.
func weather_picker(weights: Array):
	var sum: float = 0.0
	var weights_sorted = []
	var picker = randf()  # Generate a random number between 0 and 1.
	# Build a list of cumulative weights to use for picking.
	for value in weights:
		sum += value
		weights_sorted.append(sum)
	# Determine the weather type based on the random picker value.
	for i in range(5):
		if picker < weights_sorted[i]:
			return weather_list[i]  # Return the weather type corresponding to the random pick.
	# If the picker value is greater than or equal to the last weight, return "none".
	return "none"


func _ready():
	# Populate the weather forecast list for the next 4 days based on the current difficulty.
	for i in range(4):
		# Determine the weather for each of the next 4 days.
		Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	# Set the current weather to the first item in the forecast list.
	Global.current_weather = Global.weather_forcast[0]


func _on_shop_area_body_entered(body):
	# Show the shop UI when the player enters the shop area.
	if body.name == "Player":
		$shop.show()
		Global.applicable_active_screen = false

func _on_shop_area_body_exited(_body):
	# Hide the shop UI when the player exits the shop area.
	$shop.hide()
	Global.applicable_active_screen = true


func _input(event):
	# Toggle the visibility of the inventory and hotbar UI when the "toggle_inventory" action is pressed.
	if event.is_action_pressed("toggle_inventory") and Global.applicable_active_screen:
		$inventory_ui.visible = !$inventory_ui.visible
		$UI/Hotbar.visible = !$UI/Hotbar.visible
		# Pause the game when the inventory is toggled.
		get_tree().paused = true


func _on_nextday_button_pressed():
	# Advance the game to the next day and update the weather forecast.
	Global.current_day += 1
	# Remove the oldest weather forecast from the list.
	Global.weather_forcast.remove_at(0)
	# Add a new weather forecast for the new day based on the updated difficulty.
	Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	# Update the current weather to the new forecast.
	Global.current_weather = Global.weather_forcast[0]
