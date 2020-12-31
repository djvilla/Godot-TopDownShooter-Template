extends KinematicBody2D
class_name Player

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

export (float) var acceleration		= 2000.0
export (float) var speed			= 0.0
export (float) var walk_speed		= 250.0
export (float) var run_speed		= 400.0
export (float) var sneak_speed		= 125.0

var velocity 		= Vector2.ZERO
var direction 		= Vector2.ZERO
var right:			= 0.0
var left:			= 0.0
var up:				= 0.0
var down:			= 0.0

var run = false
var sneak = false
var is_firing = false
var melee = false
var weapon_current
var weapon1
var weapon2

signal player_died

# Represents the weapon two slots
enum Gun_Slots{
	PRIMARY,
	SECONDARY
}

# Maps the type of weapon the player is holding
var equipped_weapon = {
	Gun_Slots.PRIMARY: weapon1,
	Gun_Slots.SECONDARY: weapon2
}

onready var cameraFollow = $CameraFollow
onready var weaponPosition = $WeaponPosition
onready var animationPlayer = $AnimationPlayer
onready var characterMover = $CharacterMover

func _ready():
	PlayerStats.connect("player_died", self, "_on_died")
	MainInstances.Player = self
	characterMover.init(self)
	#Assign weapon
	start_weapon()
	# Call this function when everything is set up
	call_deferred("assign_world_camera")
	call_deferred("set_weapon")

func start_weapon():
	# Load starting weapons as nodes
	equipped_weapon[Gun_Slots.PRIMARY] = load("res://Scenes/Weapons/Guns/TestGun2.tscn").instance()
	equipped_weapon[Gun_Slots.SECONDARY] = load("res://Scenes/Weapons/Guns/TestGun.tscn").instance()
	
	# Add them to the scene (Adding them as a child of weapon position is temporary)
	# TODO: Once sprites are in add them as a child of player instead. This is just a visual
	# representation of melee
	weaponPosition.add_child(equipped_weapon[Gun_Slots.PRIMARY])
	weaponPosition.add_child(equipped_weapon[Gun_Slots.SECONDARY])
	
	# Equip for current weapon
	weapon_current = equipped_weapon[Gun_Slots.PRIMARY]
	equipped_weapon[Gun_Slots.SECONDARY].visible = false
	#Make Weapon Position match players
	weapon_current.global_position = weaponPosition.global_position

# Set to null when player gets destroyed
func queue_free():
	MainInstances.Player = null
	.queue_free()

func unhandled_input(event:InputEvent):
	pass
	#Decoupling all input calls from physics_process - 
	player_movement_input(event)
	if event.is_action_pressed("run"):
		run = true
	elif event.is_action_released("run"):
		run = false
	elif event.is_action_pressed("sneak"):
		sneak = true
	elif event.is_action_released("sneak"):
		sneak = false

func player_movement_input(event:InputEvent):
	if event.is_action_pressed("move_right") && right <= 0.01:
		right = event.get_action_strength("move_right")
		direction.x += right
	elif event.is_action_released("move_right"):
		direction.x -= right
		right = 0.0
	elif event.is_action_pressed("move_left") && left <= 0.01:
		left = event.get_action_strength("move_left")
		direction.x -= left
	elif event.is_action_released("move_left"):
		direction.x += left
		left = 0.0
	elif event.is_action_pressed("move_up") && up <= 0.01:
		up = event.get_action_strength("move_up")
		direction.y -= up
	elif event.is_action_released("move_up"):
		direction.y += up
		up = 0.0
	elif event.is_action_pressed("move_down") && down <= 0.01:
		down = event.get_action_strength("move_down")
		direction.y += down
	elif event.is_action_released("move_down"):
		direction.y -= down
		down = 0.0

func assign_world_camera():
	cameraFollow.remote_path = MainInstances.WorldCamera.get_path()

func set_weapon():
	PlayerStats.set_player_gun(weapon_current)

func process(delta):
	characterMover.set_move_vec(direction)
	
#func physics_process(delta):
#	velocity_logic(delta)
#	collision_logic()
#
#func velocity_logic(delta):
#	velocity = MoveStrategy.go(direction, acceleration, speed, velocity, delta)
#
#func collision_logic():
#	move_and_slide(velocity)

func set_player_speed(_speed):
	speed = _speed
	characterMover.set_speed(speed)

func facing_direction():
	# Have player face the mouse
	look_at(get_global_mouse_position())

func _on_HurtBox_hit(damage):
	print("Player Hit for: ", damage)
	PlayerStats.health -= damage

func _on_died():
	emit_signal("player_died")
	MainInstances.Player = null # Just to stop zombies from chasing you.
	queue_free()
