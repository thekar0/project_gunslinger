class_name FallingPlayerState

extends PlayerMovementState

@export var DOUBLE_JUMP_VELOCITY : float = 4.5

var DOUBLE_JUMP : bool = false

func enter(_previous_state) -> void:
	ANIMATION.pause()

func exit() -> void:
	DOUBLE_JUMP = false

func update(delta):
	PLAYER.update_input(SPEED, delta)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y = DOUBLE_JUMP_VELOCITY
	
	if PLAYER.is_on_floor():
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")
