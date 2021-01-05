extends KinematicBody2D

var player_name = "Clint"
var life = 1
var motion = Vector2(0,0)
var bullet_res = preload("res://world_objects/Bullet.tscn")
var bullets = 6

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

const SPEED = 150
const BULLET_SPEED = 1000
const RELOAD_TIME = 1

signal animate

func _physics_process(_delta):
	take_input()
	
	if is_network_master():
		rset("puppet_motion", motion)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion
	
	animate()
	
	move_and_slide(motion.normalized() * SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

func take_input():
	if life < 0 or not is_network_master():
		return

	reload()
	shoot()
	move()

func reload():
	if Input.is_action_just_pressed("p1_reload"):
		# TODO: delay shooting
		# TODO: reload sound
		bullets = 6

func shoot():
	if Input.is_action_just_pressed("p1_shoot"):
		if bullets <= 0:
			# TODO: empty gun sound
			return
		
		var target = get_viewport().get_mouse_position()
		var fire_location = position + Vector2(0, -8) * scale.x
		var direction = (target - fire_location).normalized()
		fire_location += direction * 8
		var bullet_vel = direction*BULLET_SPEED
		
		bullets -= 1
		rpc("fire_bullet", fire_location, bullet_vel, get_tree().get_network_unique_id())

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

func animate():
	emit_signal("animate", motion, life)

func hit(hitter):
	if life < 0:
		return
	life -= 1
	if life < 0:
		hitter.kill(self)
		die()

func die():
	$CollisionShape2D.queue_free()
	$CowboySprite.z_index = 0

func grow():
	self.scale += Vector2(0.5, 0.5)

func set_player_name(name):
	player_name = name

sync func fire_bullet(loc, vel, player_id):
	var bullet = bullet_res.instance()
	bullet.position = loc
	bullet.set_linear_velocity(vel)
	bullet.fired_by = player_id
	get_node("../..").add_child(bullet)
