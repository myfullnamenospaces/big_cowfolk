extends RigidBody2D

func _on_Bullet_body_entered(body):
	if body == get_parent():
		return
	if body.has_method("hit"):
		body.hit(self)
	if body.has_method("click"):
		print("click")
		body.click(self)
	
	queue_free()

func click(body):
	print("clack")

func kill(body):
	get_parent().kill(body)
