extends Node2D

var difficulty
var weather_list = ["rain", "wind", "heat", "drought", "snow"]
var early_game = [0.3, 0.1, 0.1, 0.1, 0]
var mid_game = [0.1, 0.2, 0.15, 0.15, 0.1]
var end_game = [0, 0.1, 0.1, 0.2, 0.3]


func difficulty_scaler(day):
	if day <= 14:
		difficulty = "early_game"
		return early_game
	elif day <= 28:
		difficulty = "mid_game"
		return mid_game
	else:
		difficulty = "end_game"
		return end_game


func weather_picker(weights: Array):
	var sum: float
	var weights_sorted = []
	var picker = randf()
	for value in weights:
		sum += value
		weights_sorted.append(sum)
	for i in range(5):
		if picker < weights_sorted[i]:
			return weather_list[i]
		elif picker >= weights_sorted[-1]:
			return "none"


func _ready():
	# Populate the weather forecast list for the next 4 days based on the current difficulty.
	for i in range(4):
		# Determine the weather for each of the next 4 days.
		Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	# Set the current weather to the first item in the forecast list.
	Global.current_weather = Global.weather_forcast[0]


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


func _on_shop_button_pressed():
	Global.applicable_active_screen = false
	$shop.show()
	$CanvasLayer.hide()
	$"../UI/Hotbar".hide()


func _on_deposit_quota_pressed():
	if Global.quota - Global.player_funds <= 0:
		Global.player_funds -= Global.quota
		Global.quota = 0
	else:
		Global.quota -= Global.player_funds
		Global.player_funds = 0
