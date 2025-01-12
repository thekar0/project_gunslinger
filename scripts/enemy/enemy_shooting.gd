class_name EnemyShoot

extends Node3D

enum{
	SHOOT,
	IDLE
}
var state = IDLE

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var eyes: StaticBody3D = $"."
@onready var timer: Timer = $Timer
@onready var ray: RayCast3D = $bot_gun/RayCast3D

var bullet = load("res://scenes/bullet.tscn")
var instante
var target
var health = 80

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	match(state):
		IDLE:
			animation.play("idle")
		SHOOT:
			eyes.look_at(target.global_transform.origin,Vector3.UP)
			eyes.rotation.x = 0
			eyes.rotation.z = 0
			rotate_y(deg_to_rad(eyes.rotation.y*2))


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		animation.play("shoot")
		state = SHOOT
		target = body
		timer.start()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = IDLE
		timer.stop()


func _on_timer_timeout() -> void:
	instante = bullet.instantiate()
	instante.position = ray.global_position
	instante.transform.basis = ray.global_transform.basis
	get_parent().add_child(instante)
	#color_rect.visible = true
	#await get_tree().create_timer(0.3).timeout
	#color_rect.visible = false


func damage():
	health-=20
	if health<=0:
		queue_free()
