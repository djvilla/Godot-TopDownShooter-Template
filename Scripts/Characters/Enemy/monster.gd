extends KinematicBody2D

enum States {
	IDLE,
	CHASE, 
	ATTACK, 
	DEAD
}
var cur_state = States.IDLE

var MainInstances = ResourceLoader.MainInstances

onready var characterMover = $CharacterMover
onready var animationPlayer = $AnimationPlayer
onready var healthManager = $HealthManager
onready var collisionShape = $CollisionShape2D
onready var nav : Navigation2D = get_parent() # Should be a child of Navigation

var player = null
var path = []

export (float) var sight_angle = 45.0
export (float) var turn_speed = 360.0

export (float) var attack_angle = 5.0
export (float) var attack_range = 80
export (float) var attack_rate = 0.5
export (float) var attack_anim_speed_mod = 1 #put at 0.5 for hald speed
var attack_timer : Timer
var can_attack = true

signal attack

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_rate
	attack_timer.connect("timeout", self, "finish_attack")
	attack_timer.one_shot = true
	add_child(attack_timer)
	
	healthManager.connect("dead", self, "set_state_dead")
#	healthManager.connect("gibbed", $Graphics, "hide")
	characterMover.init(self)
	set_state_idle()

func _process(delta):
	player = MainInstances.Player
	match cur_state:
		States.IDLE:
			process_state_idle(delta)
		States.CHASE:
			process_state_chase(delta)
		States.ATTACK:
			process_state_attack(delta)
		States.DEAD:
			process_state_dead(delta)

func set_state_idle():
	cur_state = States.IDLE
	characterMover.set_move_vec(Vector2.ZERO) # Stop entity from moving when switching to idle
#	anim_player.play("idle_loop")

func set_state_chase():
	cur_state = States.CHASE
#	anim_player.play("walk_loop", 0.2)

func set_state_attack():
	cur_state = States.ATTACK

func set_state_dead():
	cur_state = States.DEAD
#	anim_player.play("die")
	characterMover.freeze()
	#Move health manager down to zero so blood comes from fallen body
	collisionShape.disabled = true

func process_state_idle(delta):
	if can_see_player():
		set_state_chase()

func process_state_chase(delta):
	if player == null:
		set_state_idle()
		return
	
	if within_dist_of_player(attack_range) and has_los_player():
		set_state_attack()
	var player_pos = player.transform.origin
	var our_pos = global_transform.origin
	path = nav.get_simple_path(our_pos, player_pos)
	var goal_pos = player_pos
	if path.size() > 1:
		goal_pos = path[1]
	var dir = goal_pos - our_pos
	characterMover.set_move_vec(dir)
	face_dir(dir, delta)

func process_state_attack(delta):
	if player == null:
		set_state_idle()
		return
	
	# Stop monster from moving while attacking
	characterMover.set_move_vec(Vector2.ZERO)
	# Code for when the enemy attacks, the monster always faces the player
	# This makes it harder to dodge the enemy.
	#face_dir(global_transform.origin.direction_to(player.global_transform.origin), delta)
	if can_attack:
		if !within_dist_of_player(attack_range) or !can_see_player():
			set_state_chase()
		elif !player_within_angle(attack_angle):
			face_dir(global_transform.origin.direction_to(player.global_transform.origin), delta)
		else:
			start_attack()

func process_state_dead(delta):
	pass

func start_attack():
	can_attack = false
	animationPlayer.play("attack", -1, attack_anim_speed_mod)
	attack_timer.start()
	

func finish_attack():
	can_attack = true

func emit_attack_signal():
	emit_signal("attack")

func can_see_player():
	if player == null:
		return false
	return player_within_angle(sight_angle) and has_los_player()

func player_within_angle(angle: float):
	var dir_to_player = global_transform.origin.direction_to(player.global_transform.origin)
	var forwards = global_transform.x
	# We check 45 degs in front of the entity to see if we can see the player
	return rad2deg(forwards.angle_to(dir_to_player)) < angle && rad2deg(forwards.angle_to(dir_to_player)) > -angle

func has_los_player():
	var our_pos = global_transform.origin 
	var player_pos = player.global_transform.origin
	# Get the space raycats for the entity
	var space_state = get_world_2d().get_direct_space_state()
	# Do it on layer 2 (world layer)
	var result = space_state.intersect_ray(our_pos, player_pos, [], 2)
	# We hit something that was not the player
	if result:
		return false
	return true

func face_dir(dir: Vector2, delta):
	var angle_diff = global_transform.x.angle_to(dir)
	var turn_right = sign(global_transform.y.dot(dir))
	# If we are going to overshoot the looking direction, make our direction the one we are trying to face
	if abs(angle_diff) < deg2rad(turn_speed) * delta:
		rotation = atan2(dir.y, dir.x)
	else:
		rotation += deg2rad(turn_speed) * delta * turn_right

func alert(check_los=true):
	if cur_state != States.IDLE:
		return
	if check_los and !has_los_player():
		return
	set_state_chase()

func within_dist_of_player(dis: float):
	return global_transform.origin.distance_to(player.global_transform.origin) < attack_range


func _on_HurtBox_hit(damage):
	print("Monster Hit, damage: ", damage)
	if cur_state == States.IDLE:
		set_state_chase()
	healthManager.hurt(damage)
