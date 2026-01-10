#  enemy tank based on  simple FSM
extends CharacterBody2D

enum FSMState {Patrol, Chase}

var direction := Vector2.RIGHT
var points_array :Array
var target_pos : Vector2
var target_index : int = 0
var player_pos = null
var cur_state = FSMState.Patrol
@export var points: Node2D

@export var speed: float = 100
@onready var weapon_component: Node2D = $WeaponComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var detect_component: Area2D = $DetectComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail_compoment: Node2D = $TrailCompoment


func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)
	get_points()
	find_next_point()

func get_points():
	for point in points.get_children():
		points_array.append(point.global_position)

func find_next_point():
	if target_index >= points_array.size():
		target_index = 0
	target_pos = points_array[target_index]
	target_index += 1
	
func update_direction():
	direction = 	global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = angle_rad
	
func move_to_target():
	velocity = transform.x * speed
	move_and_slide()

func near_point():
	if global_position.distance_to(target_pos) < 5:
		return true
	else:
		return false

func find_player():
	player_pos = detect_component.get_player_pos()
	if player_pos:
		return true
	else:
		return false

func update_patrol():
	update_direction()
	move_to_target()
	if near_point():
		find_next_point()
	if find_player():
		cur_state = FSMState.Chase
		

func attack_player():
	weapon_component.target(player_pos)
	weapon_component.shoot(player_pos)

func update_chase():
	if find_player():
		target_pos = player_pos
		update_direction()
		move_to_target()
		attack_player()
	else:
		cur_state = FSMState.Patrol
		

func FSM_update():
	match cur_state:
		FSMState.Patrol:
			update_patrol()
		FSMState.Chase:
			update_chase()


func _physics_process(delta: float) -> void:	
	FSM_update()
	trail_compoment.start()


func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()
	
func on_get_damage(damage):
	animation_player.play("flash")
