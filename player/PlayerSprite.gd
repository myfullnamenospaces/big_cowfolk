extends AnimatedSprite

func _on_Player_animate(motion, life):
	if life < 0:
		play("dead")
	elif motion.x < 0:
		play("walk")
		flip_h = true
	elif motion.x > 0 or motion.y != 0:
		play("walk")
		flip_h = false
	else:
		play("idle")
