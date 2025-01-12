extends PanelContainer

@onready var property_container = %DebugVBox


func _ready() -> void:
	visible = false
	Global.debug = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible

# Add to debug screen
func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
