extends Control

@onready var lines_width: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/LinesWidth
@onready var lines_length: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer3/LinesLength
@onready var lines_gap: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer4/LinesGap
#@onready var cross_hair: Control = $"../../../CenterContainer/CrossHair"
@onready var crosshair: Control = $"."

@onready var check_dynamic_crosshair: CheckButton = $MarginContainer/VBoxContainer/HBoxContainer5/CheckDynamicCrosshair
@onready var dynamic_crosshair_label: Label = $MarginContainer/VBoxContainer/HBoxContainer5/DynamicCrosshairLabel

@onready var top: Line2D = $"../../../CenterContainer/CrossHair/Top"
@onready var right: Line2D = $"../../../CenterContainer/CrossHair/Right"
@onready var bottom: Line2D = $"../../../CenterContainer/CrossHair/Bottom"
@onready var left: Line2D = $"../../../CenterContainer/CrossHair/Left"

@onready var current_width = top.width
@onready var current_length = bottom.points[1].y - bottom.points[0].y
@onready var current_gap = bottom.points[0].y

#@onready var top_point = top.points[0].y
#@onready var right_point = right.points[0].x
#@onready var bottom_point = bottom.points[0].y
#@onready var left_point = left.points[0].x


func _ready() -> void:
	lines_width.text = str(top.width)
	lines_length.text = str(bottom.points[1].y - bottom.points[0].y)
	lines_gap.text = str(bottom.points[0].y)

func _on_lines_width_text_changed(new_text: String) -> void:
	if (float(new_text) >= 0):
		top.width = float(new_text)
		right.width = float(new_text)
		bottom.width = float(new_text)
		left.width = float(new_text)
		current_width = top.width
	if (new_text == "" and crosshair.visible == false):
		lines_width.text = "0"
		current_width = 0

func _on_lines_length_text_changed(new_text: String) -> void:
	if (float(new_text) >= 0):
		top.points[1].y -= float(new_text) - current_length
		right.points[1].x -= float(new_text) - current_length
		bottom.points[1].y += float(new_text) - current_length
		left.points[1].x += float(new_text) - current_length
		current_length = bottom.points[1].y - bottom.points[0].y
		
	else:
		lines_length.text = str(current_length)

func _on_lines_gap_text_changed(new_text: String) -> void:
	if (float(new_text) >= 0):
		top.points[0].y -= float(new_text) - current_gap
		top.points[1].y -= float(new_text) - current_gap
		right.points[0].x -= float(new_text) - current_gap
		right.points[1].x -= float(new_text) - current_gap
		bottom.points[0].y += float(new_text) - current_gap
		bottom.points[1].y += float(new_text) - current_gap
		left.points[0].x += float(new_text) - current_gap
		left.points[1].x += float(new_text) - current_gap
		current_gap = float(new_text)
	else:
		lines_gap.text = str(current_gap)

func _on_color_change_item_selected(index: int) -> void:
	if (index == 0):
		top.default_color = Color(1, 1, 1)
		right.default_color = Color(1, 1, 1)
		bottom.default_color = Color(1, 1, 1)
		left.default_color = Color(1, 1, 1)
	if (index == 1):
		top.default_color = Color(0, 0, 0)
		right.default_color = Color(0, 0, 0)
		bottom.default_color = Color(0, 0, 0)
		left.default_color = Color(0, 0, 0)
	if (index == 2):
		top.default_color = Color(57/255.0, 255/255.0, 20/255.0)
		right.default_color = Color(57/255.0, 255/255.0, 20/255.0)
		bottom.default_color = Color(57/255.0, 255/255.0, 20/255.0)
		left.default_color = Color(57/255.0, 255/255.0, 20/255.0)
	if (index == 3):
		top.default_color = Color(1, 0, 0)
		right.default_color = Color(1, 0, 0)
		bottom.default_color = Color(1, 0, 0)
		left.default_color = Color(1, 0, 0)
	if (index == 4):
		top.default_color = Color(0, 112/255.0, 1)
		right.default_color = Color(0, 112/255.0, 1)
		bottom.default_color = Color(0, 112/255.0, 1)
		left.default_color = Color(0, 112/255.0, 1)
	if (index == 5):
		top.default_color = Color(1, 1, 0)
		right.default_color = Color(1, 1, 0)
		bottom.default_color = Color(1, 1, 0)
		left.default_color = Color(1, 1, 0)
	if (index == 6):
		top.default_color = Color(1, 165/255.0, 0)
		right.default_color = Color(1, 165/255.0, 0)
		bottom.default_color = Color(1, 165/255.0, 0)
		left.default_color = Color(1, 165/255.0, 0)
	if (index == 7):
		top.default_color = Color(0, 1, 1)
		right.default_color = Color(0, 1, 1)
		bottom.default_color = Color(0, 1, 1)
		left.default_color = Color(0, 1, 1)
	if (index == 8):
		top.default_color = Color(1, 20/255.0, 147/255.0)
		right.default_color = Color(1, 20/255.0, 147/255.0)
		bottom.default_color = Color(1, 20/255.0, 147/255.0)
		left.default_color = Color(1, 20/255.0, 147/255.0)
	if (index == 9):
		top.default_color = Color(128/255.0, 0, 1)
		right.default_color = Color(128/255.0, 0, 1)
		bottom.default_color = Color(128/255.0, 0, 1)
		left.default_color = Color(128/255.0, 0, 1)
