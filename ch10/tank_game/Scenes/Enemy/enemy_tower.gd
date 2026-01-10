extends StaticBody2D

@onready var detect_component: Area2D = $DetectComponent
@onready var weapon_component: Node2D = $WeaponComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	health_component.died.connect(on_died)
	hurt_box_component.get_damage.connect(on_get_damage)
	
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	find_player()

func find_player():
	if detect_component.can_see_player():
		var target_pos = detect_component.player_ref.global_position
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)

func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()

func on_get_damage(damage):
	animation_player.play("flash")
