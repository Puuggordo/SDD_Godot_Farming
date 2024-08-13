extends Control

@onready var day1 = $HBoxContainer/Today
@onready var day2 = $HBoxContainer/Tomorrow
@onready var day3 = $HBoxContainer/AfterTomorrow
@onready var day4 = $HBoxContainer/AfterAfterTomorrow
@onready var quota = $HBoxContainer2/Quota

func _process(delta):
	day1.text = Global.weather_forcast[0] + ", "
	day2.text = Global.weather_forcast[1] + ", "
	day3.text = Global.weather_forcast[2] + ", " 
	day4.text = Global.weather_forcast[3]
	quota.text = "Quota: " + str(Global.quota) + " honey due in " + str(Global.days_until_quota) + " days"
