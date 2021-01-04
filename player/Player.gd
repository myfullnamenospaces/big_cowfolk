extends "res://player/Cowboy.gd"

sync func fire_bullet(loc, vel, player_id):
	var bullet = bullet_res.instance()
	bullet.position = loc
	bullet.set_linear_velocity(vel)
	bullet.fired_by = player_id
	get_node("../..").add_child(bullet)

func shoot():
	if Input.is_action_just_pressed("p1_shoot") and is_network_master():
		var target = get_viewport().get_mouse_position()
		var fire_location = position + Vector2(0, -8) * scale.x
		var direction = (target - fire_location).normalized()
		fire_location += direction * 8
		var bullet_vel = direction*BULLET_SPEED
		
		rpc("fire_bullet", fire_location, bullet_vel, get_tree().get_network_unique_id())

func move():
	motion = Vector2(0,0)
	if is_network_master():
		if Input.is_action_pressed("p1_left"):
			motion.x = -1
		if Input.is_action_pressed("p1_right"):
			motion.x = 1
		if Input.is_action_pressed("p1_up"):
			motion.y = -1
		if Input.is_action_pressed("p1_down"):
			motion.y = 1
