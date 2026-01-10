#  enemy tank based on FSM
extends CharacterBody2D

@export var points: Node2D

@export var speed: float = 100
@onready var weapon_component: Node2D = $WeaponComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var search_component: Node2D = $SearchComponent
@onready var avoid_component: Node2D = $AvoidComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail_compoment: Node2D = $TrailCompoment


func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)

func _physics_process(delta: float) -> void:
	trail_compoment.start()
	
		
func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()
	
func on_get_damage(damage):
	animation_player.play("flash")

func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)

	if avoid_component.obstackes_detected():
		direction = avoid_component.get_new_direction()
		
	var angle_rad = direction.angle()
	var delta = get_physics_process_delta_time()
	rotation = rotate_toward(rotation,angle_rad,2*PI*delta )
	
func move():
	velocity = transform.x * speed
	move_and_slide()
