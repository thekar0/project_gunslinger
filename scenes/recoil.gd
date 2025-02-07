extends Node3D

@export var recoil: Vector3
@export var snap: float
@export var speed: float  

@onready var gun: Node3D = $Camera3D/model_19 #jakos trzeba bedzie wykombinowac zeby przy roznych broniach byl recoil a nie tylko rewolwerze xpp
@onready var player = $"../.."

var current_rot: Vector3
var target_rot: Vector3

func _ready() -> void:
	gun.shake.connect(add_recoil)
	
func _process(delta: float) -> void:
	target_rot = lerp(target_rot,Vector3.ZERO,speed*delta)
	current_rot = lerp(current_rot,target_rot,snap*delta)
	basis = Quaternion.from_euler(current_rot)
	
func add_recoil():
	target_rot += Vector3(recoil.x,randf_range(-recoil.y,recoil.y),randf_range(-recoil.z,recoil.z))
