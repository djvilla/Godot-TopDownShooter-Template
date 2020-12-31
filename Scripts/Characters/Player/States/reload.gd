extends PlayerState

func unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("melee"):
		player.animationPlayer.stop()
		_state_machine.transition_to('Melee', {})
	elif event.is_action_pressed("primary_weapon"):
		player.animationPlayer.stop()
		_state_machine.transition_to('SwapWeapon', {"event": "primary"})
	elif event.is_action_pressed("secondary_weapon"):
		player.animationPlayer.stop()
		_state_machine.transition_to('SwapWeapon', {"event": "secondary"})
	player.unhandled_input(event)

#func physics_process(delta:float)->void:
#	player.physics_process(delta)

func process(delta:float)->void:
	player.process(delta)
	player.facing_direction()
	state_check()

func enter(msg:Dictionary = {})->void:
	reload_weapon()
	if(msg.has("speed")):
		match msg["speed"]:
			"walk":
				player.set_player_speed(player.walk_speed)
#				player.speed = player.walk_speed
			"run":
				player.set_player_speed(player.run_speed)
#				player.speed = player.run_speed
			"sneak":
				player.set_player_speed(player.sneak_speed)
#				player.speed = player.sneak_speed
	#animation.play("Walk")

func exit()->void:
	pass

func state_check():
	pass
#	if abs(player.direction.x) < 0.01 and abs(player.direction.y) < 0.01:
#		_state_machine.transition_to('Idle', {})
#	if !player.run:
#		_state_machine.transition_to('Walk', {})

func reload_weapon():
	player.animationPlayer.play("reload")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "reload":
		player.weapon_current.reload_gun()
		player.PlayerStats.ammo_change()
		_state_machine.transition_to("Idle", {})
