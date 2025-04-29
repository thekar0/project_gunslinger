extends Node3D

signal shake

var decal = preload("res://scenes/objects/small_objects/decal.tscn") 

@onready var camera_3d: Camera3D = %Camera3D
@onready var gun_anim: AnimationPlayer = $glock2/AnimationPlayer
@onready var hand_anim: AnimationPlayer = $hands/AnimationPlayer
@onready var flash: GPUParticles3D = $MuzzleFlash/GPUParticles3D
@onready var light: OmniLight3D = $MuzzleFlash/OmniLight3D
@onready var hands_anim_tree : AnimationTree = $hands/AnimationTree
@onready var gun_anim_tree : AnimationTree = $glock2/AnimationTree
@onready var label = $"../../../../UI/Magazine/Label"
var flash_time = 0.05

var recoil = 0.12
var head_rotation

var shooting = false
var prevanim = ""
enum {IDLE, WALK}
var currAnim = IDLE

var mag_capacity: int = 16
var mag_bullets: int = 16
var mag_reload: int = mag_capacity / 2

func _ready() -> void:
	light.visible = false
	
func _AnimInfo(anim):
	if anim == "Walk":
		currAnim = WALK
	elif anim == "Idle":
		currAnim = IDLE
	_playAnim()


func _playAnim():
	match currAnim:
		IDLE:
			hands_anim_tree.set("parameters/Movement/transition_request", "idle")
			gun_anim_tree.set("parameters/Movement/transition_request", "idle")
		WALK:
			hands_anim_tree.set("parameters/Movement/transition_request", "walk")
			gun_anim_tree.set("parameters/Movement/transition_request", "walk")

func _reload():
	mag_bullets = mag_capacity

func _shoot(rayCast: RayCast3D, head: Node3D,delta: float):
	shooting = true
	if true: #!gun_anim.is_playing():
		#_playAnim("Fire")
		hands_anim_tree.set("parameters/shoot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		gun_anim_tree.set("parameters/shoot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		#camera_3d.add_trauma(3.0)
		#muzzle flash
		mag_bullets -= 1
		print(mag_bullets)
		shooting = false
		light.visible = true
		flash.emitting = true
		await get_tree().create_timer(flash_time).timeout
		light.visible = false
		
		if rayCast.is_colliding():
			if(rayCast.get_collider().is_in_group("enemies")):
				rayCast.get_collider().damage()
			else:
				var instance = decal.instantiate()
				get_tree().root.add_child(instance)
				instance.global_position = rayCast.get_collision_point()
				instance.look_at(instance.global_transform.origin + rayCast.get_collision_normal(),Vector3.UP)
				if rayCast.get_collision_normal() != Vector3.UP and rayCast.get_collision_normal() != Vector3.DOWN:
					instance.rotate_object_local(Vector3(1,0,0), 90)
				shake.emit()
				await get_tree().create_timer(1).timeout
				var fade = get_tree().create_tween()
				fade.tween_property(instance,"modulate:a",0,1.5)
				await get_tree().create_timer(1.5).timeout
				instance.queue_free()
				return
		shake.emit()

func camera_shake(head: Node3D):
	#recoil , camera shake
	head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
	head.rotation.x += recoil
	head.rotation_degrees.y += randf_range(-3.0,3.0)*recoil
