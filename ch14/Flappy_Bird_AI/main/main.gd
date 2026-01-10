extends Node2D

var pipes_scene: PackedScene = preload("res://pipes/pipes.tscn")
@onready var spawn_point = $SpawnPoint
@onready var timer = $Timer
@onready var pipes_group = $PipesGroup
@onready var ceil = $Ceil
@onready var floor = $Floor
@onready var bird = $Bird


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.GameOver.connect(on_game_over)
	ceil.body_entered.connect(on_border_body_enter)
	floor.body_entered.connect(on_border_body_enter)
	new_pipes()
	timer.start()

		
func new_pipes():
	var pipes = pipes_scene.instantiate()
	var pos_y = randf_range(spawn_point.position.y - GameManager.GAP,
							spawn_point.position.y + GameManager.GAP)
	pipes.global_position.x = spawn_point.position.x
	pipes.global_position.y	= pos_y
	pipes_group.add_child(pipes)
	
func on_game_over():
	timer.stop()
	reset_game()
	
func _on_timer_timeout():
	new_pipes()

func on_border_body_enter(body):
	if body.is_in_group("bird") and not body.is_dead:
		GameManager.GameOver.emit()

func reset_game():
	bird.global_position = Vector2(160,300)
	var pipes = pipes_group.get_children()
	for pipe in pipes:
		pipe.queue_free()
	call_deferred("new_pipes")
	timer.start()
