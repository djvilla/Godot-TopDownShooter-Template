extends "res://Scripts/Weapon/Bullet/projectile.gd"

# Will not run process function until set true in the AnimationPlayer
func _ready():
	#SoundFx.play("Bullet", rand_range(0.6, 1.2), SoundFx.volume)
	#set_process(true)
	start_movement()
