extends Node

@export_range(0,100) var floatefwfe:float = 0
var difficulty
var weather_list = ["rain", "wind", "heat", "drought", "snow"]
var early_game = [0.3, 0.1, 0.1, 0.1, 0]
var mid_game = [0.1, 0.2, 0.15, 0.15, 0.1]
var end_game = [0, 0.1, 0.1, 0.2, 0.3]
var output = []
var water =0
var wind =0
var heat=0
var drought=0
var snow=0
var none =0

func _ready():
	randomize()
	tester(early_game)

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


func tester(weight):
	for i in range (7):
		weather_picker(weight)
		output.append(Global.current_weather)
	for i in range(output.size()):
		if output[i]=="rain":
			water +=1
		elif output[i]=="wind":
			wind +=1
		elif output[i]=="heat":
			heat +=1
		elif output[i]=="drought":
			drought +=1
		elif output[i]=="snow":
			snow +=1
		elif output[i] =="none":
			none +=1
	print(water)
	print(wind)
	print(heat)
	print(drought)
	print(snow)
	print(none)


func _on_button_pressed():
	Global.current_day += 1
	weather_picker(difficulty_scaler(Global.current_day))
	print ("date: ", Global.current_day)
	print("difficulty: ", difficulty)
	print("weather: ", Global.current_weather)
	print("")
