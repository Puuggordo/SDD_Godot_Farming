extends CharacterBody2D

@export var speed = 75

func get_input(speed):
	# Gets vector input from the WASD keys, setup in the Input Map.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("left"):
		animator(true,"left")
	elif Input.is_action_pressed("right"):
		animator(true,"right")
	elif Input.is_action_pressed("up"):
		animator(true,"up")
	elif Input.is_action_pressed("down"):
		animator(true,"down")
	else:
		animator(false,"down")
	# Current velocity vector in pixels per second, used and modified during calls to move_and_slide().
	velocity = input_direction * speed


func animator(moving, direction):
	var sprite = $AnimatedSprite2D
	var animation = ""
	if direction == "left":
		sprite.flip_h = true
		if moving:
			animation = "side_walk"
		else:
			animation = "side_idle"
	elif direction == "right":
		sprite.flip_h = false
		if moving:
			animation = "side_walk"
		else:
			animation = "side_idle"
	elif direction == "up":
		if moving:
			animation = "up_walk"
		else:
			animation = "up_idle"
	elif direction == "down":
		if moving:
			animation = "down_walk"
		else:
			animation = "down_idle"
	sprite.play(animation)


func _physics_process(_delta):
	get_input(speed)
	# Moves the player based on velocity. If the player collides with a body, it will slide along the body rather than stop immediately. 
	move_and_slide()
