extends Node2D

@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D

@export var force: float = 2

func obstackes_detected():
	return shape_cast_2d.is_colliding()


func get_new_direction():
	if obstackes_detected():
		var normal_vec = shape_cast_2d.get_collision_normal(0)
		var direction = owner.transform.x + normal_vec * force
		return direction
