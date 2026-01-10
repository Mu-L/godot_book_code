extends RayCast2D
class_name Sensor

enum Direction {Horizontal , Vertical, Degree45}

@export var direction: Direction
var max_distance :int

func _ready():
	if direction == Direction.Horizontal:
		max_distance = abs(target_position.x)
	if direction == Direction.Vertical:
		max_distance = abs(target_position.y)
	if direction ==Direction.Degree45:
		max_distance = abs(target_position.x) * sqrt(2)

func get_distance():
	if is_colliding():
		var distance = global_position.distance_to(get_collision_point())
		return distance/max_distance
	else:
		return 1.0
		
