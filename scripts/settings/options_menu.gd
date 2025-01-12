class_name OptionsMenu

extends PanelContainer

@onready var exit: Button = $MarginContainer/VBoxContainer/Exit
@onready var options_menu: OptionsMenu = $"."


func _ready() -> void:
	set_process(false)


func _on_general_pressed() -> void:
	#$Graphics.visible = false
	#$Audio.visible = false
	$Controls.visible = false
	$General.visible = true

func _on_graphics_pressed() -> void:
	$General.visible = false
	#$Audio.visible = false
	$Controls.visible = false
	#$Graphics.visible = true
#
func _on_audio_pressed() -> void:
	$General.visible = false
	#$Graphics.visible = false
	$Controls.visible = false
	#$Audio.visible = true

func _on_controls_pressed() -> void:
	$General.visible = false
	#Graphics.visible = false
	#Audio.visible = false
	$Controls.visible = true

func _on_exit_pressed() -> void:
	$General.visible = true
	#Graphics.visible = false
	#Audio.visible = false
	$Controls.visible = false
	options_menu.visible = false
	$"../SettingsPanel/MarginContainer".visible = true
	set_process(false)
