extends "res://player/Cowboy.gd"

func shoot():
	if Input.is_action_just_pressed("p1_shoot"):
		var target = get_viewport().get_mouse_position()
		var fire_location = position + Vector2(0, -8) * scale.x
		var direction = (target - fire_location).normalized()
		
		var bullet = bullet_res.instance()
		add_child(bullet)
		bullet.set_global_position(fire_location)
		
		bullet.position += direction * 8
		bullet.set_linear_velocity(direction*BULLET_SPEED)

func move():
	motion = Vector2(0,0)
	if Input.is_action_pressed("p1_left"):
		motion.x = -1
	if Input.is_action_pressed("p1_right"):
		motion.x = 1
	if Input.is_action_pressed("p1_up"):
		motion.y = -1
	if Input.is_action_pressed("p1_down"):
		motion.y = 1
