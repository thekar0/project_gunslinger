extends VehicleBody3D

var isActive = false
var player = null

@export var STEER_LIMIT = 0.8
@export var HORSE_POWER = 7 * 100

func _physics_process(delta):
	#print(isActive)
	if player != null:
		if Input.is_action_just_pressed("use") and isActive == false:
			isActive = true
			print("entered")
			player.can_move = false
			player.can_shoot = false
			player.gun.hide()
			player.get_node("CollisionShape3D").disabled = true
			
		elif Input.is_action_just_pressed("use") and isActive:
			print("exited")
			player.global_position = $exit_driver_seat.global_position
			player.can_move = true
			player.can_shoot = true
			player.get_node("CollisionShape3D").disabled = false
			player.gun.show()
			player = null
			isActive = false
			
		if isActive:
			steering = move_toward(steering, Input.get_axis("move_right", "move_left"), STEER_LIMIT * delta * 2)
			engine_force = Input.get_axis("move_backward", "move_forward") * HORSE_POWER
			player.global_position = $driver_seat.global_position
