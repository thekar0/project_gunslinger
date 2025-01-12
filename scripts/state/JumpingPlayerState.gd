class_name JumpingPlayerState

extends PlayerMovementState

@export var JUMP_VELOCITY : float = 4.5
@export var DOUBLE_JUMP_VELOCITY : float = 4.5
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85

var DOUBLE_JUMP : bool = false

@export var DOUBLE_JUMP_ENABLED : bool = true
@export var BUNNYHOP_ENABLED : float = true

func enter(_previous_state) -> void:
	if !BUNNYHOP_ENABLED:
		PLAYER.velocity.y += JUMP_VELOCITY
	elif BUNNYHOP_ENABLED:
		PLAYER.velocity.y = JUMP_VELOCITY
	ANIMATION.play("jump_start")

# Reset double jump
func exit() -> void:
	if DOUBLE_JUMP_ENABLED:
		DOUBLE_JUMP = false


func update(delta):
	PLAYER.update_input(SPEED, delta)
	PLAYER.update_velocity()
	
	# Double jumps
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP and DOUBLE_JUMP_ENABLED:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
	
	# Dynamic jumps
	if Input.is_action_just_released("jump") and PLAYER.velocity.y > 0:
		PLAYER.velocity.y = PLAYER.velocity.y / 2.0
	
	# End Jump
	if PLAYER.is_on_floor() and (!BUNNYHOP_ENABLED or (BUNNYHOP_ENABLED and !Input.is_action_pressed("jump"))):
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")
	
	# Bunnyhop restart
	if PLAYER.is_on_floor() and BUNNYHOP_ENABLED and Input.is_action_pressed("jump"):
		PLAYER.velocity.y = JUMP_VELOCITY
		DOUBLE_JUMP = false
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		if (BUNNYHOP_ENABLED and !Input.is_action_pressed("jump")) or !BUNNYHOP_ENABLED:
			transition.emit("FallingPlayerState")
