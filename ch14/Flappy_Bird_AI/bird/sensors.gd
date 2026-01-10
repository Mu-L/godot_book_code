extends Node2D


func get_observation():
	var distances: Array
	for child in get_children():
		distances.append(child.get_distance())
	return distances
	
