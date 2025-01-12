class_name GrabbingPlayerState

extends PlayerMovementState

@export var TOP_ANIM_SPEED : float = 2.2

func enter(previousState) -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, delta)
	PLAYER.update_velocity()
