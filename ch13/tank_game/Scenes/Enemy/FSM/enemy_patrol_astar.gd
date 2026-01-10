# using astar
extends State


@export var enemy: Node2D
@export  var search_component :Node2D
@export var target_dis: int = 10
var patrol_points :Array
var patrol_target : Vector2
var move_points: Array
var move_target : Vector2
var move_index :int = 0


func _ready() -> void:
	get_patrol_point()

func enter():
	get_next_patrol_point()
	find_next_point()
	
func physics_update(delta: float) -> void:
	enemy.update_direction(move_target)
	enemy.move()
	if near_point():
		find_next_point()
	if search_component.can_see_player():
		transitioned.emit(self,"EnemyAttack")
	
func get_patrol_point():
	for point in enemy.points.get_children():
		patrol_points.append(point.global_position)
	

func get_next_patrol_point():
	patrol_target = patrol_points.pick_random()
	move_index = 0
	move_points = enemy.map.get_road_path(enemy.global_position, patrol_target)

	
func find_next_point():
	if not move_points.is_empty():
		move_target = move_points[move_index]
		move_index += 1
		if move_index >= move_points.size():
			get_next_patrol_point()
		

func near_point():
	if enemy.global_position.distance_to(move_target) < target_dis:
		return true
	else:
		return false
		
