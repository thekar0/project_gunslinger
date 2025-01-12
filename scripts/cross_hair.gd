#class_name CrossHair

extends Control

# DOT SETTINGS
@export var DOT_RADIUS: float = 1.0
@export var DOT_COLOR: Color = Color.WHITE

# LINES SETTINGS
@onready var RETICLE_LINES: Array[Line2D] = [$Top,$Right,$Bottom,$Left]
@export var PLAYER_CONTROLLER: CharacterBody3D
@export var RETICLE_SPEED: float = 0.1
@export var RETICLE_DISTANCE: float = 5.0
@export var MAX_RETICLE_DISTANCE: float = 60.0

var paused: bool = false

func _ready() -> void:
	queue_redraw()
	Global.reticle = self

func _process(_delta: float) -> void:
	if paused:
		return
	adjust_reticle_lines()

func _draw() -> void:
	draw_circle(Vector2(0, 0), DOT_RADIUS, DOT_COLOR)

func adjust_reticle_lines():
	var vel = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3(0, 0, 0)
	var pos = Vector2(0, 0)
	var speed = origin.distance_to(vel)
	
	if is_nan(speed):
		speed = 0
	
	var distance = speed * RETICLE_DISTANCE
	distance = clamp(distance, 0, MAX_RETICLE_DISTANCE)
	
	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(0, -distance), RETICLE_SPEED)
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(-distance, 0), RETICLE_SPEED)
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(0, distance), RETICLE_SPEED)
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(distance, 0), RETICLE_SPEED)
