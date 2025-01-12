extends CharacterBody3D

@export var player_path : NodePath
var player = null
var speed = 3.0
@onready var nav_agent = $NavigationAgent3D
var health = 60

var agro_distance = 10.0

var current_target_position: Vector3 = Vector3.ZERO
var idle_rotation_speed: float = 5.0


func _ready():
	player = get_node(player_path)


func _process(delta):
	if health <= 0:
		queue_free()
	
	if should_chase_player():
		current_target_position = player.global_transform.origin
	else:
		current_target_position = global_transform.origin
		rotate_y(idle_rotation_speed * delta)
	
	nav_agent.set_target_position(current_target_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
	move_and_slide()
	lobotomy()


func should_chase_player() -> bool:
	if player == null:
		return false
	
	var overlaps = $VisionArea.get_overlapping_bodies()
	
	return player in overlaps


func lobotomy():
	if Input.is_action_just_pressed("lobotomy"):
		speed = 0


func damage():
	health-=20
	if health<=0:
		queue_free()
