extends Control

@onready var quota = %Quota

func _process(delta):
	for i in range(%WeatherContainer.get_child_count()):
		var weather_item = %WeatherContainer.get_child(i)
		var label = weather_item.get_node("CenterContainer/Label")
		var weather = Global.weather_forcast[i]
		label.text = weather
		label.add_theme_color_override("font_color", Color.WHITE)
		match weather:
			"rain": weather_item.color = Color.html("2c83ff")
			"drought": weather_item.color = Color.html("ad7f36")
			"wind": weather_item.color = Color.html("1da500")
			"heat": weather_item.color = Color.html("f13c00")
			"snow": 
				weather_item.color = Color.html("9cdeff")
				label.add_theme_color_override("font_color", Color.BLACK)
			"none": 
				weather_item.color = Color.html("d6d8d8")
				label.add_theme_color_override("font_color", Color.BLACK)
	quota.text = "Quota: " + str(Global.quota) + " honey due in " + str(Global.days_until_quota) + " days"
