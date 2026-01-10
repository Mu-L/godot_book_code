extends Area2D

enum Pickups {GUN, HEALTH}

signal get_pickup(pos:Vector2, pickup_type:Pickups)

@export var pickup_type :Pickups = Pickups.HEALTH
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body:Node2D):
	if body.is_in_group("Player"):
		if pickup_type == Pickups.GUN:
			body.upgrade_weapon()
		elif pickup_type == Pickups.HEALTH:
			body.upgrade_health()
		animation_player.play("pickup")
		await animation_player.animation_finished
		queue_free()
