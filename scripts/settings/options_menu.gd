class_name OptionsMenu

extends PanelContainer

@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var options_menu: OptionsMenu = $"."


func _ready() -> void:
	set_process(false)


func _on_general_pressed() -> void:
	$Controls.visible = false
	$Crosshair.visible = false
	$General.visible = true

func _on_graphics_pressed() -> void:
	$General.visible = false
	$Controls.visible = false
	$Crosshair.visible = false

func _on_audio_pressed() -> void:
	$General.visible = false
	$Controls.visible = false
	$Crosshair.visible = false

func _on_controls_pressed() -> void:
	$General.visible = false
	$Crosshair.visible = false
	$Controls.visible = true

func _on_crosshair_pressed() -> void:
	$General.visible = false
	$Controls.visible = false
	$Crosshair.visible = true


func _on_exit_pressed() -> void:
	$General.visible = true
	$Controls.visible = false
	$Crosshair.visible = false
	options_menu.visible = false
	$"../SettingsPanel/MarginContainer".visible = true
	set_process(false)
