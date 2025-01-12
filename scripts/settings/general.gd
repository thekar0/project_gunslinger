class_name General

extends Control

@onready var FOV_SLIDER = get_node("MarginContainer/VBoxContainer/FOVChange")
@onready var SENSITIVITY_SLIDER = get_node("MarginContainer/VBoxContainer/SensitivityChange")
@onready var player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	FOV_SLIDER.set_value(75)

# FOV Slider
func _on_fov_change_value_changed(value: float) -> void:
	var camera = %Camera3D
	var fov_label = $MarginContainer/VBoxContainer/FOVLabel
	FOV_SLIDER.set_min(30)
	FOV_SLIDER.set_max(120)
	camera.fov = value
	fov_label.text = "Current FOV: " + str(value)


#Sensitivity Slider
func _on_sensitivity_change_value_changed(value: float) -> void:
	var sensitivity_label: Label = $MarginContainer/VBoxContainer/SensitivityLabel
	SENSITIVITY_SLIDER.min_value = 0.01
	SENSITIVITY_SLIDER.max_value = 5
	player.MOUSE_SENSITIVITY = value
	sensitivity_label.text = "Current Sensitivity: " + str(value)


func _on_left_pressed() -> void:
	var gun = %Camera3D/gun
	var hand_label: Label = $MarginContainer/VBoxContainer/HandLabel
	gun.position.x = -0.25
	#gun.rotation.x = player.gun_rotation
	gun.rotation.y = deg_to_rad(-4)
	hand_label.text = "Current Hand: Left"
	player.current_hand = "left"


func _on_right_pressed() -> void:
	var gun = %Camera3D/gun
	var hand_label: Label = $MarginContainer/VBoxContainer/HandLabel
	gun.position.x = 0.25
	#gun.rotation.x = player.gun_rotation
	gun.rotation.y = deg_to_rad(4)
	hand_label.text = "Current Hand: Right"
	player.current_hand = "right"
