extends Node2D

@onready var shadow: Sprite2D = $Shadow



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	make_shadow()

func make_shadow():
	global_position = owner.global_position
	shadow.rotation = owner.rotation - PI/2
