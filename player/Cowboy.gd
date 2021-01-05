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
	shoot()
	
	move()
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

func reload():
	bullets = 6

func shoot():
	pass

func move():
	pass

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
