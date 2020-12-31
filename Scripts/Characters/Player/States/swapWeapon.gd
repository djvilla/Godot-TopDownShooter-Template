extends PlayerState

var dic:Dictionary

func unhandled_input(event:InputEvent)->void:
	if event.is_action_pressed("melee"):
		player.animationPlayer.stop()
		_state_machine.transition_to('Melee', {})
	player.unhandled_input(event)

#func physics_process(delta:float)->void:
#	player.physics_process(delta)

func process(delta:float)->void:
	player.process(delta)
	player.facing_direction()
	state_check()

func enter(msg:Dictionary = {})->void:
	check_current_weapon(msg)
	dic = msg
	swap_weapon()
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

# If the player is trying to swap to the weapon they are currently holding
# then just return to the idle state.
func check_current_weapon(msg:Dictionary):
	if(msg["event"] == "primary" && player.weapon_current == player.equipped_weapon[player.Gun_Slots.PRIMARY]):
		_state_machine.transition_to("Idle", {})
	elif (msg["event"] == "secondary" && player.weapon_current == player.equipped_weapon[player.Gun_Slots.SECONDARY]):
		_state_machine.transition_to("Idle", {})

func swap_weapon():
	player.animationPlayer.play("swap_weapon")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "swap_weapon":
		if dic["event"] == "primary":
			player.weapon_current = player.equipped_weapon[player.Gun_Slots.PRIMARY]
			player.equipped_weapon[player.Gun_Slots.PRIMARY].visible = true
			player.equipped_weapon[player.Gun_Slots.SECONDARY].visible = false
		elif dic["event"] == "secondary":
			player.weapon_current = player.equipped_weapon[player.Gun_Slots.SECONDARY]
			player.equipped_weapon[player.Gun_Slots.SECONDARY].visible = true
			player.equipped_weapon[player.Gun_Slots.PRIMARY].visible = false
		#Make Weapon Position match players
		player.weapon_current.global_position = player.weaponPosition.global_position
		player.PlayerStats.set_player_gun(player.weapon_current)
		_state_machine.transition_to("Idle", {})
