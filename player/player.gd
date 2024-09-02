extends CharacterBody2D

@export var speed = 75

# Variable to store the last direction moved
var last_direction = "up"


func get_input(speed):
	# Gets vector input from the WASD keys, set up in the Input Map.
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_pressed("left"):
		animator("left")
		last_direction = "left"
	elif Input.is_action_pressed("right"):
		animator("right")
		last_direction = "right"
	elif Input.is_action_pressed("up"):
		animator("up")
		last_direction = "up"
	elif Input.is_action_pressed("down"):
		animator("down")
		last_direction = "down"
	else:
		# If no movement keys are pressed, set the character to idle in the last direction
		animator(last_direction)

	# Current velocity vector in pixels per second, used and modified during calls to move_and_slide().
	velocity = input_direction * speed

func animator(direction):
	var sprite = $AnimatedSprite2D2
	var animation = ""

	if direction == "left":
		sprite.flip_h = false
		animation = "side"
	elif direction == "right":
		sprite.flip_h = true
		animation = "side"
	elif direction == "up":
		animation = "up"
	elif direction == "down":
		animation = "down"

	sprite.play(animation)

func _physics_process(_delta):
	get_input(speed)
	# Moves the player based on velocity. If the player collides with a body, it will slide along the body rather than stop immediately.
	move_and_slide()



#func get_input(speed):
	## Gets vector input from the WASD keys, set up in the Input Map.
	#var input_direction = Input.get_vector("left", "right", "up", "down")
#
	#if Input.is_action_pressed("left"):
		#animator(true, "left")
		#last_direction = "left"
	#elif Input.is_action_pressed("right"):
		#animator(true, "right")
		#last_direction = "right"
	#elif Input.is_action_pressed("up"):
		#animator(true, "up")
		#last_direction = "up"
	#elif Input.is_action_pressed("down"):
		#animator(true, "down")
		#last_direction = "down"
	#else:
		## If no movement keys are pressed, set the character to idle in the last direction
		#animator(false, last_direction)
#
	## Current velocity vector in pixels per second, used and modified during calls to move_and_slide().
	#velocity = input_direction * speed
#
#func animator(moving, direction):
	#var sprite = $AnimatedSprite2D
	#var animation = ""
#
	#if direction == "left":
		#sprite.flip_h = true
		#animation = "side_walk" if moving else "side_idle"
	#elif direction == "right":
		#sprite.flip_h = false
		#animation = "side_walk" if moving else "side_idle"
	#elif direction == "up":
		#animation = "up_walk" if moving else "up_idle"
	#elif direction == "down":
		#animation = "down_walk" if moving else "down_idle"
#
	#sprite.play(animation)

