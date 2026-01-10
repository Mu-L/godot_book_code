extends ShapeCast2D

@export var force: float = 2

#func _process(delta: float) -> void:
	#get_new_direction()

func obstackes_detected():
	return is_colliding()


func get_new_direction():
	if obstackes_detected():
		var normal_vec = get_collision_normal(0)
		#print("normal vector: %s" %normal_vec)
		var direction = owner.transform.x + normal_vec * force
		#print("owner right vector: %s" %owner.transform.x)
		#print("new direction: %s" %direction)
		return direction
