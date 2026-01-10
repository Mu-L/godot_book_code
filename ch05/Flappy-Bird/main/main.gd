extends Node2D

const GAP = 180
var pipes_scene: PackedScene = preload("res://pipes/pipes.tscn")

@onready var timer: Timer = $Timer
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var bird: CharacterBody2D = $Bird
@onready var ceil: Area2D = $Ceil
@onready var floor: Area2D = $Floor
@onready var pipes_group: Node2D = $PipesGroup


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.GameOver.connect(on_game_over)
	GameManager.GameStart.connect(on_game_start)
	ceil.body_entered.connect(on_border_body_enter)
	floor.body_entered.connect(on_border_body_enter)
	timer.timeout.connect(on_timer_timeout)
	
func on_game_start():
	new_pipes()
	timer.start()
		
func new_pipes():
	var pipes = pipes_scene.instantiate()
	var pos_y = randf_range(spawn_point.position.y - GAP,
							spawn_point.position.y + GAP)
	pipes.global_position.x = spawn_point.position.x
	pipes.global_position.y	= pos_y
	pipes_group.add_child(pipes)
	
func on_game_over():
	timer.stop()
	reset_game()
	
func on_timer_timeout():
	new_pipes()

func on_border_body_enter(body):
	if body.is_in_group("bird") and not body.is_dead:
		GameManager.GameOver.emit()

func reset_game():
	bird.global_position = Vector2(160,300)
	var pipes = pipes_group.get_children()
	for pipe in pipes:
		pipe.queue_free()
