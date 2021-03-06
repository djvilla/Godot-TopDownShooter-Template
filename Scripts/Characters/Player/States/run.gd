extends PlayerState

func unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("fire"):
		_state_machine.transition_to('Shoot', {"speed": "run"})
	elif event.is_action_pressed("melee"):
		_state_machine.transition_to('Melee', {"speed": "run"})
	elif event.is_action_pressed("reload"):
		_state_machine.transition_to('Reload', {"speed": "run"})
	elif event.is_action_pressed("primary_weapon"):
		_state_machine.transition_to('SwapWeapon', {"speed": "run", "event": "primary"})
	elif event.is_action_pressed("secondary_weapon"):
		_state_machine.transition_to('SwapWeapon', {"speed": "run", "event": "secondary"})
	else:
		player.unhandled_input(event)

#func physics_process(delta:float)->void:
#	player.physics_process(delta)

func process(delta:float)->void:
	player.process(delta)
	player.facing_direction()
	state_check()

func enter(msg:Dictionary = {})->void:
	player.set_player_speed(player.run_speed)
#	player.speed = player.run_speed
	#animation.play("Walk")

func exit()->void:
	pass

func state_check():
	if abs(player.direction.x) < 0.01 and abs(player.direction.y) < 0.01:
		_state_machine.transition_to('Idle', {})
	if !player.run:
		_state_machine.transition_to('Walk', {})

