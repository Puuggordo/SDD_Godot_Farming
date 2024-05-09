extends StaticBody2D

var selected = false
var seed_type = "onion"


func _ready():
	$AnimatedSprite2D.play("default")


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		Global.plant_selected = seed_type
		selected = true


func _physics_process(delta):
	if selected:
		global_position = global_position.lerp(get_global_mouse_position(),15 * delta)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			selected = false

