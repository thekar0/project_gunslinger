extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_3d: Camera3D = $Camera3D

func _ready() -> void:
	animation_player.play("background_camera_rotate", 0, true)
