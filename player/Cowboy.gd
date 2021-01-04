extends KinematicBody2D

var life = 1
var motion = Vector2(0,0)
var bullet_res = preload("res://world_objects/Bullet.tscn")

const SPEED = 150
const BULLET_SPEED = 1000

signal animate

func _physics_process(_delta):
	shoot()
	move()
	animate()
	
	move_and_slide(motion.normalized() * SPEED)

func shoot():
	pass

func move():
	pass

func animate():
	emit_signal("animate", motion, life)

func hit(body):
	if life < 0:
		return
	print("I'm shot!")
	life -= 1
	if life < 0:
		body.kill(self)
		die()

func kill(body):
	print("Got 'em!")
	grow()

func die():
	print("PEACE OUT")
	$CollisionShape2D.queue_free()
	$CowboySprite.z_index = 0

func grow():
	self.scale += Vector2(0.5, 0.5)
	
