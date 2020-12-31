extends Node2D

signal ammo_amount_changed(ammo_amount, current_total_ammo)

const Bullet = preload("res://Scenes/Weapons/Bullet/Bullet.tscn") 

export (String) var weapon_name		= ""
export (int) var bullet_speed 		= 1000
export (int) var fire_rate			= 1
export (int) var damage				= 1
export (int) var max_ammo			= 10
export (int) var clip_size			= 5

var current_total_ammo 				= max_ammo		# In inherited guns ready function you need to override this
var ammo_amount										= 1# Need to set this in the ready function
var can_fire 						= true
var is_reloading 					= false

onready var bullet_spawn = $Sprite/Muzzle
onready var alertAreaHearing = $AlertAreaHearing
onready var alertAreaLos = $AlertAreaLos

func weapon_path():
	return get_path()

# Allows the character to fire the weapon when they can fire, when they are not meleeing
# and they are not currently reloading
func use_weapon(character):
	if can_fire && !is_reloading:
		if ammo_amount > 0:
			var bullet_instance = _create_bullet_instance(character.rotation, character.rotation_degrees)
			# Using properties above, spawn bullet
			character.get_tree().get_root().add_child(bullet_instance)
			# Animation here for smoke or flash
			# Reduce ammunition
			#bullet_instance.set_damage(damage)
			_reduce_ammo()
#			if bullet_sfx.stream != bullet_noise:
#				bullet_sfx.stream = bullet_noise
			# Alert nearby enemies once you fire a gun
			alert_nearby_enemies()
		else:
			pass # play empty clip noise
#			if bullet_sfx.stream != bullet_noise_empty:
#				bullet_sfx.stream = bullet_noise_empty
		
#		bullet_sfx.play() # 0.1 skips that click at the beginning of the audio clip
		# Set the fire rate boolean and timer 
		can_fire = false
		yield(character.get_tree().create_timer(fire_rate), "timeout")
		can_fire = true

# Function handles enabling fire for this weapon
# Was created to stop the weapon from firing during reloading
func enable_fire():
	is_reloading = false

# Function handles disabling fire for this weapon.
# Was created to stop the weapon from firing during reloading
func disable_fire():
	is_reloading = true

# Function to check if the character can reload this weapon.
# Can only reload when not firing weapon and not in the middle of reloading
func can_reload():
	if current_total_ammo == 0:
		return false
	else:
		return true

# Function to reload the gun if the current amount does not equal zero
func reload_gun():
	if can_reload():
		var ammo_needed = clip_size - ammo_amount
		if ammo_needed < current_total_ammo:
			ammo_amount += ammo_needed
			current_total_ammo -= ammo_needed
		else:
			ammo_amount += current_total_ammo
			current_total_ammo -= current_total_ammo

# Update the signal when weapons are switched. For Label
func update_ammo():
	emit_signal("ammo_amount_changed", ammo_amount, current_total_ammo)

# Function that returns the current ammo and total ammo
func current_ammo():
	return{
		in_mag = ammo_amount,
		overall_ammo = current_total_ammo
	}

# This function creates an instance of a bullet on the given bullet spawn.
# matches the characters direction
func _create_bullet_instance(rotation, rotation_degrees):
	var bullet_instance = Bullet.instance()
	bullet_instance.position = bullet_spawn.get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_speed
	bullet_instance.shoot_rotation = rotation
	#bullet_instance.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated(rotation))
	return bullet_instance

# Increase the amount of ammo the player is holding
func increase_ammo(value):
	var new_ammo_amount = current_total_ammo + value
	current_total_ammo = clamp(new_ammo_amount, 0, max_ammo)
	update_ammo()

# Reduce the amount of ammo the weapon currently has when called
func _reduce_ammo():
	ammo_amount -= 1
	update_ammo()

func alert_nearby_enemies():
	var nearby_enemies = alertAreaLos.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert()
	nearby_enemies = alertAreaHearing.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert(false)
