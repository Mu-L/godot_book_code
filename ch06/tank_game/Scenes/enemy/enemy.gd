extends Area2D


@export var bullet_scene: PackedScene
@export var health: int = 3

@onready var gun: Sprite2D = $Gun
@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Gun/Marker2D
@onready var player = get_tree().get_first_node_in_group("Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	timer.timeout.connect(on_time_out)
	timer.start(1)
	Gamemanager.player_killed.connect(on_player_killed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	find_player()
	
func find_player():
	var player_pos = player.global_position
	gun.look_at(player_pos)
	
func on_time_out():
	shoot()
	timer.start(randf_range(1,3))
	
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = marker_2d.global_position
	bullet.rotation = gun.rotation
	bullet.top_level = true
	add_child(bullet)
	
func reduce_health():
	if health > 0:
		health -= 1
	if health <= 0:
		Gamemanager.enemy_killed.emit(global_position)
		queue_free()	
	


func on_player_killed():
	timer.stop()
