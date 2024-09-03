extends Node2D

var difficulty
var weather_list = ["rain", "wind", "heat", "drought", "snow"]
var early_game = [0.3, 0.1, 0.1, 0.1, 0]
var mid_game = [0.1, 0.2, 0.15, 0.15, 0.1]
var end_game = [0, 0.1, 0.1, 0.2, 0.3]


func difficulty_scaler(day):
	# Determine the game's difficulty level based on the current day.
	if day <= 14:
		# Days 1-14 are considered "early game"
		difficulty = "early_game"
		return early_game
	elif day <= 28:
		# Days 15-28 are considered "mid game"
		difficulty = "mid_game"
		return mid_game
	else:
		# Days beyond 28 are considered "end game"
		difficulty = "end_game"
		return end_game


func weather_picker(weights: Array):
	var sum: float
	var weights_sorted = []
	# Generate a random float between 0 and 1 to determine the weather
	var picker = randf()
	# Calculate the cumulative weights to create a weighted selection
	for value in weights:
		sum += value
		weights_sorted.append(sum)
	# Loop through the first five elements in the weather list
	for i in range(5):
		# If the random number falls within the current cumulative weight, return the corresponding weather
		if picker < weights_sorted[i]:
			return weather_list[i]
		# If the random number is greater than or equal to the last cumulative weight, return "none"
		elif picker >= weights_sorted[-1]:
			return "none"


func _ready():
	# Populate the weather forecast list for the next 4 days based on the current difficulty.
	for i in range(4):
		# Determine the weather for each of the next 4 days.
		Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	# Set the current weather to the first item in the forecast list.
	Global.current_weather = Global.weather_forcast[0]

func _process(delta):
	if Global.quota > 0 and Global.player_funds == 0 and Global.days_until_quota == 0:
		$GameOverScreen.show()
		get_tree().paused = true

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Global.applicable_active_screen = false
		$CanvasLayer.show()
		$"../UI/Hotbar".hide()


func _on_area_2d_body_exited(body):
	Global.applicable_active_screen = true
	$CanvasLayer.hide()
	$shop.hide()
	$"../UI/Hotbar".show()


func _on_sleep_button_pressed():
	if Global.days_until_quota > 0 or Global.quota == 0:
		Global.player_funds += Global.player_pollen * 10
		Global.player_pollen = 0
		Global.current_day += 1
		Global.days_until_quota -= 1
		Global.weather_forcast.remove_at(0)
		Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
		Global.current_weather = Global.weather_forcast[0]
		Global.applicable_active_screen = true
		$CanvasLayer.hide()
		$"../UI/Hotbar".show()
		$CanvasLayer/Control/RichTextLabel.hide()
	else:
		$CanvasLayer/Control/RichTextLabel.show()

func _on_shop_button_pressed():
	Global.applicable_active_screen = false
	$shop.show()
	$CanvasLayer.hide()
	$"../UI/Hotbar".hide()


func _on_deposit_quota_pressed():
	# Check if the player has enough funds to fully meet the quota
	if Global.quota - Global.player_funds <= 0:
		# If the player has enough funds, subtract the quota amount from player funds
		Global.player_funds -= Global.quota
		# Set the quota to 0, as it has been fully met
		Global.quota = 0
	# If the player doesn't have enough funds to fully meet the quota,
	else:
 		# Subtract the player's funds from the quota
		Global.quota -= Global.player_funds
		# Set the player's funds to 0, as they have been fully used to pay towards the quota
		Global.player_funds = 0
