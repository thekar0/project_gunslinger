extends Camera3D
@export var trauma_reduction_rate := 1.0

@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0

@export var noise : FastNoiseLite
@export var noise_speed := 50.0

var trauma := 0.0

var time := 0.0


func _process(delta):
	time += delta
	if time > 20.0:
		time = 0.0
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)

	rotation_degrees.x = max_x * get_shake_intensity() * get_noise_from_seed(0)
	rotation_degrees.y = max_y * get_shake_intensity() * get_noise_from_seed(1)
	rotation_degrees.z = max_z * get_shake_intensity() * get_noise_from_seed(2)

func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
