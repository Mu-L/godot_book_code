extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tw = create_tween()
	tw.tween_interval(1)
	tw.tween_property(self, "modulate",Color(1,1,1,0),0.5)
	tw.tween_callback(queue_free)
