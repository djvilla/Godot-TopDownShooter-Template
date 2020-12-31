extends KinematicBody2D



func _on_HurtBox_hit(damage):
	print(damage)
	queue_free()
