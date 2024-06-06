extends CharacterBody2D

func get_input(speed):
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
	velocity = input_direction * speed


func animator(movement, direction):
	var sprite = $AnimatedSprite2D
	var animation = ""
	if direction == "left":
		sprite.flip_h = true
		if movement:
			animation = "side_walk"
		else:
			animation = "side_idle"
	elif direction == "right":
		sprite.flip_h = false
		if movement:
			animation = "side_walk"
		else:
			animation = "side_idle"
	elif direction == "up":
		if movement:
			animation = "up_walk"
		else:
			animation = "up_idle"
	elif direction == "down":
		if movement:
			animation = "down_walk"
		else:
			animation = "down_idle"
	sprite.play(animation)


func _physics_process(_delta):
	get_input(75)
	move_and_slide()
