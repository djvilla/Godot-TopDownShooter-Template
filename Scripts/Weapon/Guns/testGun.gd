extends "res://Scripts/Weapon/Guns/gun.gd"

func _ready() -> void:
	# Overwrite inital values
	weapon_name = "Rifle"
	max_ammo = 40
	ammo_amount = max_ammo
	current_total_ammo = max_ammo
	clip_size = 20
	ammo_amount = clip_size
	fire_rate = 0.5
	damage = 2
	
