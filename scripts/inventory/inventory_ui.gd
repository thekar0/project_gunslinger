class_name InventoryUI

extends PanelContainer

@onready var inventory: PanelContainer = $"."
@onready var settings_panel: Settings = $"../SettingsPanel"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventoryMenu()

	if Input.is_action_just_pressed("settings"):
		inventory.visible = false

	if Input.is_action_just_pressed("inventory") and settings_panel.visible == true:
		inventory.visible = false

func inventoryMenu():
	if inventory.visible == false:
		inventory.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		inventory.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
