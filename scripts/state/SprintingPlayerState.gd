class_name SprintingPlayerState

extends PlayerMovementState

@export var TOP_ANIM_SPEED : float = 1.6


func enter(_previous_state) -> void:
	#if ANIMATION.is_playing() and ANIMATION.current_animation == "jump_end":
		#await ANIMATION.animation_finished
		#ANIMATION.play("sprinting", 0.5, 1.0)
	#else:
		#ANIMATION.play("sprinting", 0.5, 1.0)
	pass


func exit() -> void:
	ANIMATION.speed_scale = 1.0


func update(delta):
	PLAYER.update_input(SPRINT_SPEED, delta)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint") or Input.is_action_just_released("move_forward"):
		transition.emit("WalkingPlayerState")
	
	if PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")
	
	if Input.is_action_just_pressed("crouch") and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
	
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if Input.is_action_just_pressed("scope") and PLAYER.is_on_floor():
		transition.emit("ScopingPlayerState")


func set_animation_speed(anim_speed):
	var alpha = remap(anim_speed, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(PLAYER.velocity.length(), TOP_ANIM_SPEED, alpha)
