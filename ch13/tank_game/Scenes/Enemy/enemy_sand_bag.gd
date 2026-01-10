extends StaticBody2D

@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	hurt_box_component.get_damage.connect(on_get_damage)
	health_component.died.connect(on_died)

func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	queue_free()
	
func on_get_damage(damage):
	animation_player.play("flash")
