class_name CrouchingPlayerState

extends PlayerMovementState

@export_range(1, 6, 0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D

var RELEASED : bool = false


func enter(previous_state) -> void:
	ANIMATION.speed_scale = 1.0
	
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("crouching", -1.0, CROUCH_SPEED)
		
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "crouching"
		ANIMATION.seek(1.0, true)


func exit() -> void:
	RELEASED = false


func update(delta) -> void:
	PLAYER.update_input(SPEED, delta)
	PLAYER.update_velocity()
	
	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif !Input.is_action_pressed("crouch") and !RELEASED:
		RELEASED = true
		uncrouch()
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

# uncrouches, if it cannot wait 0.1s
func uncrouch():
	if !CROUCH_SHAPECAST.is_colliding() and !Input.is_action_pressed("crouch"):
		ANIMATION.play("crouching", -1.0, -CROUCH_SPEED * 1.5, true)
		
		if ANIMATION.is_playing():
			await ANIMATION.animation_finished
		transition.emit("IdlePlayerState")
		
	elif CROUCH_SHAPECAST.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
