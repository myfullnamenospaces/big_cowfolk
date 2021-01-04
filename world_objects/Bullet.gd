extends RigidBody2D

var fired_by = -1

func _on_Bullet_body_entered(body):
	var player = get_node("../Players/%s" % fired_by)
	if body == player:
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
	var player = get_node("../Players/%s" % fired_by)
	player.grow()
