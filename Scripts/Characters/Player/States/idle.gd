extends PlayerState

func unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("fire"):
		_state_machine.transition_to('Shoot', {})
	elif event.is_action_pressed("melee"):
		_state_machine.transition_to('Melee', {})
	elif event.is_action_pressed("reload"):
		_state_machine.transition_to('Reload', {})
	elif event.is_action_pressed("primary_weapon"):
		_state_machine.transition_to('SwapWeapon', {"event": "primary"})
	elif event.is_action_pressed("secondary_weapon"):
		_state_machine.transition_to('SwapWeapon', {"event": "secondary"})
	else:
		player.unhandled_input(event)

#func physics_process(delta:float)->void:
#	player.physics_process(delta)

func process(delta:float)->void:
	player.process(delta)
	player.facing_direction()
	state_check()

func state_check():
	if abs(player.direction.x) > 0.01 or abs(player.direction.y) > 0.01:
		_state_machine.transition_to('Walk', {})

func enter(msg:Dictionary = {})->void:
	player.set_player_speed(player.walk_speed)
#	player.speed = player.walk_speed
	#animation.play("Idle")

func exit()->void:
	pass
