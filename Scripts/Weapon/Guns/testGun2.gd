extends "res://Scripts/Weapon/Guns/gun.gd"

func _ready() -> void:
	# Overwrite inital values
	weapon_name = "Pistol"
	max_ammo = 80
	ammo_amount = max_ammo
	current_total_ammo = max_ammo
	clip_size = 30
	ammo_amount = clip_size
	fire_rate = 0.1
	damage = 2
	
