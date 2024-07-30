extends Node2D

var difficulty
var weather_list = [0,1,2,3,4]
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
			Global.current_weather = weather_list[i]
			break
		elif picker >= weights_sorted[-1]:
			Global.current_weather = "none"
			break


func _ready():
	$shop.hide()


func _on_shop_area_body_entered(body):
	if body.name == "Player":
		$shop.show()


func _on_shop_area_body_exited(_body):
	$shop.hide()


func _on_nextday_button_pressed():
	Global.current_day += 1
	weather_picker(difficulty_scaler(Global.current_day))
