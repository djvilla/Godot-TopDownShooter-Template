extends PlayerState

func unhandled_input(event:InputEvent)->void:
	if event.is_action_released("fire"):
		_state_machine.transition_to("Idle", {})
	elif event.is_action_pressed("melee"):
		_state_machine.transition_to('Melee', {})
	player.unhandled_input(event)

func physics_process(delta:float)->void:
	fire_gun()
#	player.physics_process(delta)

func process(delta:float)->void:
	player.process(delta)
	player.facing_direction()
	state_check()

func enter(msg:Dictionary = {})->void:
	player.set_player_speed(player.walk_speed)
#	player.speed = player.walk_speed
	#animation.play("Walk")

func exit()->void:
	pass

func state_check():
	pass

func fire_gun():
	player.weapon_current.use_weapon(player)
	# Updates UI ammo count
	player.PlayerStats.ammo_change()
	#Check if player is pressing the fire key, and if they can aim
	#if input.is_firing && AIM[state]:
	#player.weapon_current.use_weapon(player)
