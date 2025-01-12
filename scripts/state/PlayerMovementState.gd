class_name PlayerMovementState

extends State

@export var SPEED : float = 5.0
@export var SPRINT_SPEED : float = 7.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25

var PLAYER : Player
var ANIMATION : AnimationPlayer

func _ready() -> void:
	await owner.ready
	PLAYER = owner as Player
	ANIMATION = PLAYER.ANIMATION_PLAYER

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, delta)
	PLAYER.update_velocity()
