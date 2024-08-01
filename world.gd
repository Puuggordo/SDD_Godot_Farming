extends Node2D

var difficulty
var weather_list = ["rain", "wind", "heat", "drought", "snow"]
var early_game = [0.3, 0.1, 0.1, 0.1, 0]
var mid_game = [0.1, 0.2, 0.15, 0.15, 0.1]
var end_game = [0, 0.1, 0.1, 0.2, 0.3]

func difficulty_scaler(day):
	if day <= 7:
		difficulty = "early_game"
		return early_game
	elif day <= 14:
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
	$shop.hide()
	for i in range(4):
		Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	Global.current_weather = Global.weather_forcast[0]

func _on_shop_area_body_entered(body):
	if body.name == "Player":
		$shop.show()


func _on_shop_area_body_exited(_body):
	$shop.hide()


func _on_nextday_button_pressed():
	Global.current_day += 1
	Global.weather_forcast.remove_at(0)
	Global.weather_forcast.append(weather_picker(difficulty_scaler(Global.current_day)))
	Global.current_weather = Global.weather_forcast[0]
