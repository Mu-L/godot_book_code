#  enemy tank based on Standard FSM

extends CharacterBody2D

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


func _physics_process(delta: float) -> void:
	trail_compoment.start()
	
func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()
	
func on_get_damage(damage):
	animation_player.play("flash")

func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = angle_rad

func move():
	velocity = transform.x * speed
	move_and_slide()
