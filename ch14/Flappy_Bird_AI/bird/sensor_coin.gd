extends Area2D



func get_distance():
	if has_overlapping_areas():
		var others = get_overlapping_areas()
		if others.size()>0:
			var other = others[0]
			var distance = other.global_position.y- global_position.y
			return distance/800
	else:
		return 0
