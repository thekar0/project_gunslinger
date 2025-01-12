class_name Settings

extends PanelContainer

@onready var options_menu: OptionsMenu = $"../OptionsMenu"
@onready var player: Player = $"../.."
func _ready() -> void:
	visible = false
	Global.settings = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("settings"):
		pauseMenu()
		


func pauseMenu():
	if visible:
		Engine.time_scale = 1
		show()
		Global.player.can_shoot = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		options_menu.visible = false
		$MarginContainer.visible = true
		$"../OptionsMenu/General".visible = true
		#$"../OptionsMenu/Graphics".visible = false
		#$"../OptionsMenu/Audio".visible = false
		$"../OptionsMenu/Controls".visible = false
	else:
		Engine.time_scale = 0
		hide()
		Global.player.can_shoot = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = !visible
	Global.reticle.paused = visible

# RESUME
func _on_resume_pressed() -> void:
	pauseMenu()

# ENTER OPTIONS MENU
func _on_options_pressed() -> void:
	$MarginContainer.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	$"../OptionsMenu/General".visible = true
	
# QUIT
func _on_quit_pressed() -> void:
	#get_tree().quit()
	get_tree().change_scene_to_file('res://scenes/ui/main_menu.tscn')
