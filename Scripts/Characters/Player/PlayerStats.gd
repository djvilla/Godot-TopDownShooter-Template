extends Resource
class_name PlayerStats

signal player_weapon_change(weapon_name)
signal player_ammo_change(currentAmmo, maxAmmo)

onready var current_gun

var max_health = 4
var health = max_health setget set_health

signal player_health_changed(value)
signal player_died

func set_health(value):
	# When player takes damage, emit signal
	if value < health:
		pass #Events.emit_signal("add_screenshake", 0.25, 0.5)
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	if health <= 0:
		emit_signal("player_died")

func gain_health(value):
	var newHealth = health + value
	set_health(newHealth)

func refill_stats():
	self.health = max_health

func set_player_gun(new_gun):
	current_gun = new_gun
	emit_signal("player_weapon_change", current_gun.weapon_name)
	print("Current weapon name " + current_gun.weapon_name)
	ammo_change()

func ammo_change():
	var ammo_values = current_gun.current_ammo()
	emit_signal("player_ammo_change", ammo_values.in_mag, ammo_values.overall_ammo)
