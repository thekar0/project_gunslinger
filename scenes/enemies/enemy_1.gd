extends CharacterBody3D

@onready var player = null

const SPEED = 4.0
var health = 200

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

var blood = preload("res://scenes/enemies/blood_decal.tscn")

func _ready() -> void:
	player = get_node(player_path)
	
func _process(delta: float) -> void:
	if player != null:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		move_and_slide()

func damage():
	health-=20
	var blood_stain = blood.instantiate()
	get_tree().root.add_child(blood_stain)
	blood_stain.global_transform.origin = $blood_spawn.global_transform.origin
	if health<=0:
		queue_free()
	print($blood_fx.emitting)


func _on_navigation_agent_3d_target_reached() -> void:
	player.hurt()
