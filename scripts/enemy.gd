extends CharacterBody3D

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D

var player = null
var speed = 3.0
var health = 60


func _ready():
	player = get_node(player_path)

func _process(delta):
	if health <= 0:
		queue_free()
	
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized()*speed
	move_and_slide()
