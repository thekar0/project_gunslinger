class_name Player

extends CharacterBody3D

const MAX_SPEED_GROUND = 7
const MAX_SPEED_AIR = 4
const GROUND_ACCEL = MAX_SPEED_GROUND * 10
const AIR_ACCEL = MAX_SPEED_AIR * 3
const FRICTION = 7
const JUMP_VELOCITY = 4
const GRAVITY = 11

# CAMERA MOVEMENT
@export var MOUSE_SENSITIVITY : float = 0.1
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var ANIMATION_PLAYER : AnimationPlayer

@export var inventory: Inventory

var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
# Later assigned as _rotation_input in _update_camera func
var _current_rotation : float
var is_fullscreen : bool = false
var health = 80
var bullet = load("res://scenes/bullet.tscn")
var instance
var current_hand : String = "right"

# Base animation player for all animations



@onready var cross_hair: CenterContainer = $CenterContainer
@onready var player = $"."
@onready var gun = $CameraController/recoil/Camera3D/gun
@onready var CAMERA_CONTROLLER: Node3D = $CameraController
@onready var ANIMATION_GUN : AnimationPlayer = $CameraController/recoil/Camera3D/gun/AnimationPlayer
@onready var spawn_point : Node3D = $"../SpawnPoint"
@onready var camera_pivot = %Camera3D
#FOR OBJECT PICKING
@onready var hand = $CameraController/recoil/Camera3D/Hand
@onready var usage_ray_cast: RayCast3D = $CameraController/recoil/Camera3D/usage_ray_cast
@onready var shoot_ray_cast: RayCast3D = $CameraController/recoil/Camera3D/shoot_ray_cast
@onready var gun_anim: AnimationPlayer = $glock2/AnimationPlayer
@onready var hand_anim: AnimationPlayer = $hands/AnimationPlayer
var activeObject
#FOR OBJECT PICKING

const gun_rotation = 0.05
var lerp_speed = 9.0

var can_shoot = true
var can_move = true
# Custom gravity for RigidBody
var gravity = 9.0

func _ready() -> void:
	Engine.time_scale = 1
	Global.player = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print(spawn_point)
	gun.label.text = str(gun.mag_bullets)

func _process(delta: float) -> void:
	#_update_camera(delta)
	CAMERA_CONTROLLER.rotation_degrees.z = 0
	if Input.is_action_just_pressed("reload"):
		gun._reload()
		gun.label.text = str(gun.mag_bullets)
	
	if can_shoot and is_on_floor() and gun.mag_bullets > 0:
		if Input.is_action_just_pressed("shoot"):
			gun._shoot(shoot_ray_cast,CAMERA_CONTROLLER,delta)
			gun.label.text = str(gun.mag_bullets)
	
func _physics_process(delta: float) -> void:
	enterCar()
	aim_n_shoot(delta)
	object_picking()
	debug_screen(delta)

func _input(event: InputEvent) -> void:
	# toggle_fullscreen = F11
	if (event is InputEventMouseMotion) and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY*0.1))
		CAMERA_CONTROLLER.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY*0.1))
		CAMERA_CONTROLLER.rotation.x = clamp(CAMERA_CONTROLLER.rotation.x,deg_to_rad(-89),deg_to_rad(89))
	if event.is_action_pressed("toggle_fullscreen"):
		if !is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		is_fullscreen = !is_fullscreen

	
#FOR PLAYERSTATE MACHINES
func update_input(speed: float, delta) -> void:
	if can_move:
		var vector = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var wishdir = (transform.basis * Vector3(vector.x, 0, vector.y)).normalized()
		if is_on_floor():
			velocity = accelerate(wishdir, delta, GROUND_ACCEL, MAX_SPEED_GROUND)
			speed = velocity.length()
			if speed != 0:
				if speed > 2:
					gun._AnimInfo("Walk")
				else:
					#print(speed)
					gun._AnimInfo("Idle")
				var drop = speed * FRICTION * delta
				velocity *= max(speed - drop, 0) / speed
				#print(speed)
			else:
				#print(speed)
				gun._AnimInfo("Idle")
		else:
			velocity = accelerate(wishdir, delta, AIR_ACCEL, MAX_SPEED_AIR)
			
		velocity.y -= GRAVITY * delta
		velocity.x = clamp(velocity.x, -10, 10)
		velocity.z = clamp(velocity.z, -10, 10)

func accelerate(direction, delta, ACCEL_TYPE, MAX_SPEED):
	var proj_vel = velocity.dot(direction)
	var accel_vel = ACCEL_TYPE * delta
	if (proj_vel + accel_vel > MAX_SPEED):
		accel_vel = MAX_SPEED - proj_vel
	return velocity + (direction * accel_vel)

func update_velocity() -> void:
	move_and_slide()
#FOR PLAYERSTATE MACHINES

func debug_screen(delta):
	# while vsync is on, fps stay at monitor refresh rate
	var frames_per_second : String = "%.0f" % (1.0/delta)
	var round_mouse = [snapped(_mouse_rotation.x, 0.001), snapped(_mouse_rotation.y, 0.001)]
	
	# Displays these properties in debug screen (~)
	Global.debug.add_property("FPS", frames_per_second, 0)
	Global.debug.add_property("Mouse_Rotation", round_mouse, 1)
	Global.debug.add_property("Movement_Velocity", snapped(velocity.length(), 0.01), 2)
#DEVELOPER

#PLAYER CONTROL
func aim_n_shoot(delta):
	if Input.is_action_pressed("scope"):
		gun.position.x = lerp(gun.position.x,0.0,lerp_speed*delta)
		gun.rotation.x = lerp(gun.rotation.x,-gun_rotation,lerp_speed*delta)
		gun.rotation.y = lerp(gun.rotation.y,0.0,lerp_speed*delta)
	else:
		var hand_lerp
		var hand_deg
		if current_hand == "right":
			hand_lerp = 0.25
			hand_deg = 4
		elif current_hand == "left":
			hand_lerp = -0.25
			hand_deg = -4
		gun.position.x = lerp(gun.position.x,hand_lerp,lerp_speed*delta)
		gun.rotation.x = lerp(gun.rotation.x,gun_rotation,lerp_speed*delta)
		gun.rotation.y = lerp(gun.rotation.y,deg_to_rad(hand_deg),lerp_speed*delta)
	
#PLAYER CONTROL

func object_picking():
	if activeObject != null:
		activeObject.set_linear_velocity((hand.global_transform.origin - activeObject.global_transform.origin) * 20)
		if abs(abs(player.global_position) - abs(activeObject.global_position)) > Vector3(2, 2, 2):
			activeObject.lock_rotation = false
			activeObject = null
			can_shoot = true
			gun.show()
	if Input.is_action_just_pressed("use") and activeObject == null:
		var collider = usage_ray_cast.get_collider()
		if collider != null and collider is RigidBody3D and collider.is_in_group("pickable"):
			activeObject = collider
			activeObject.lock_rotation = true
			can_shoot = false
			gun.hide()
	elif Input.is_action_just_pressed("use") and activeObject != null:
		activeObject.lock_rotation = false
		activeObject = null
		can_shoot = true
		gun.show()

func hurt():
	ANIMATION_PLAYER.play("hit_player")
	health -= 20
	#if health <= 0:
		#respawn()

func respawn():
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.2).timeout
	self.position.x = spawn_point.position.x
	self.position.z = spawn_point.position.z
	health = 80
	Engine.time_scale = 1

func enterCar():
	if Input.is_action_just_pressed("use") and usage_ray_cast.get_collider() is VehicleBody3D and usage_ray_cast.get_collider().is_in_group("cars"):
		usage_ray_cast.get_collider().player = player
		
func camera_shake(recoil: float):
	camera_pivot.rotation.x += recoil
	camera_pivot.rotation_degrees.y += randf_range(-3.0,3.0)*recoil

#funckja w komentaerzu bo kolidowała z gun recoil
#func _unhandled_input(event: InputEvent) -> void:
	#_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	#if _mouse_input:
		#_rotation_input = -event.relative.x * MOUSE_SENSITIVITY / 10
		#_tilt_input = -event.relative.y * MOUSE_SENSITIVITY / 10
		
			#var camera = $CameraController/Camera3D
			#var space_state = camera.get_world_3d().direct_space_state #<--swiat w ktorym bedzie raycast
			#var screen_center = get_viewport().size / 2
			#var origin = camera.project_ray_origin(screen_center)
			#var end = origin + camera.project_ray_normal(screen_center) * 5000
			#var query = PhysicsRayQueryParameters3D.create(origin, end)
			#query.collide_with_bodies = true
			#var result = space_state.intersect_ray(query)
			#if result:
				#if result.collider.is_in_group("enemies"):
					#result.collider.health -= 20
					#print("hit")
					
#DEVELOPER to samo co wcześniej funckja w komentaerzu bo kolidowała z gun recoil
#func _update_camera(delta):
	#_current_rotation = _rotation_input
	#
	# Rotates camera using euler rotation
	#_mouse_rotation.x += _tilt_input * delta
	#_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	#_mouse_rotation.y += _rotation_input * delta
	#
	#_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	#_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	#
	#CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	#global_transform.basis = Basis.from_euler(_player_rotation)
	#
	#CAMERA_CONTROLLER.rotation.z = 0.0
	#
	#_rotation_input = 0.0
	#_tilt_input = 0.0
