class_name State

extends Node

signal transition(new_state_name: StringName)

func enter(_previous_state) -> void:
	transition.emit()
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
