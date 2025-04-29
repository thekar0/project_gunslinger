extends Decal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	var fade = get_tree().create_tween()
	fade.tween_property(self,"modulate:a",0,1.5)
	await get_tree().create_timer(1.5).timeout
	queue_free()
