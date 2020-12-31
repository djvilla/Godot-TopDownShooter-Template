extends RigidBody2D

# const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

#var velocity = Vector2.ZERO
#var bullet_speed = 1000.0
var velocity = 0.0
var shoot_rotation = 0

func _process(delta):
	pass
	#position += velocity * delta

func start_movement():
	apply_impulse(Vector2.ZERO, Vector2(velocity, 0).rotated(shoot_rotation))

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Hitbox_body_entered(body):
	#Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()


func _on_Hitbox_area_entered(area):
	#Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()
