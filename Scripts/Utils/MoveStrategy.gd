extends Node

func go(direction, acceleration, max_speed=0, motion=Vector2.ZERO, delta=0):
	if direction == Vector2.ZERO:  #If we are getting movement
		motion = apply_friction(acceleration * delta, motion)
	else:
		motion = apply_movement(direction * acceleration * delta, motion, max_speed)
	
	return motion

func apply_friction(amount, motion):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
	return motion

func apply_movement(acceleration, motion, max_speed):
	motion += acceleration
	motion = motion.clamped(max_speed) #Clamps it at the max speed
	return motion
