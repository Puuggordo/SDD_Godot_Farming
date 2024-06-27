extends StaticBody2D

var plant = Global.plant_selected
var plant_growing = false
var plant_grown = false
var previous_day = Global.current_day

func _ready():
	$plant_growing.play("none")


func _process(delta):
	if Global.current_day == previous_day + 1:
		previous_day = Global.current_day
		$plant_growing.frame += 1


func _physics_process(_delta):
	if plant_growing == false:
		plant = Global.plant_selected


func _on_area_2d_area_entered(_area):
	if !plant_growing:
		if plant == "carrot":
			plant_growing = true
			$carrot_timer.start()
			$plant_growing.play("carrot")
		elif plant == "onion":
			plant_growing = true
			$onion_timer.start()
			$plant_growing.play("onion")
		elif plant == "strawberry":
			plant_growing = true
			$onion_timer.start()
			$plant_growing.play("strawberry")
		else:
			$plant_growing.play("none")
	else:
		pass


func plant_timer():
	if $plant_growing.frame == 0:
		$plant_growing.frame = 1
		$carrot_timer.start()
	elif $plant_growing.frame == 1:
		$plant_growing.frame = 2
		plant_grown = true


func _on_carrot_timer_timeout():
	plant_timer()


func _on_onion_timer_timeout():
	plant_timer()


func _on_strawberry_timer_timeout():
	plant_timer()


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("click"):
		if plant_grown:
			if plant == "carrot":
				Global.carrot_number += 1
				plant_growing = false
				plant_grown = false
				$plant_growing.play("none")
			elif plant == "onion":
				Global.onion_number += 1
				plant_growing = false
				plant_grown = false
				$plant_growing.play("none")
			elif plant == "strawberry":
				Global.strawberry_number += 1
				plant_growing = false
				plant_grown = false
				$plant_growing.play("none")



