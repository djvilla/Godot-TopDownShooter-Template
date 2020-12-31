extends Node2D

var body_to_move : KinematicBody2D = null

export (float) var acceleration		= 2000.0
export (float) var speed			= 0.0
var drag = 0.0

var move_vec : Vector2
var velocity : Vector2
export var ignore_rotation = false # True for AI because when you ignore rotation you use global coordinates.

signal movement_info

var frozen = false

#func _ready():
#	drag = acceleration / speed

# Set the character that this script will be moving
func init(_body_to_move: KinematicBody2D):
	body_to_move = _body_to_move

func set_move_vec(_move_vec: Vector2):
	move_vec = _move_vec.normalized()

func set_speed(_speed: float):
	speed = _speed

func _physics_process(delta):
	if frozen:
		return
	var cur_move_vec = move_vec
	# For the player to move in the direction they rotated
#	if !ignore_rotation:
#		cur_move_vec = cur_move_vec.rotated(body_to_move.rotation)
	velocity = MoveStrategy.go(cur_move_vec, acceleration, speed, velocity, delta)
	body_to_move.move_and_slide(velocity)
	
	emit_signal("movement_info", velocity)

func freeze():
	frozen = true

func unfreeze():
	frozen = false
