extends Node2D

@onready var coin = $Coin
@onready var pipe: Area2D = $Pipe
@onready var pipe_2: Area2D = $Pipe2
@onready var animation_player = $Coin/AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var passed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pipe.body_entered.connect(on_pipe_body_entered)
	pipe_2.body_entered.connect(on_pipe_body_entered)
	coin.body_entered.connect(on_coin_body_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(on_exited)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += delta * GameManager.speed


func on_pipe_body_entered(body):
	if body.is_in_group("bird") and not body.is_dead:
		GameManager.GameOver.emit()
	
func on_game_over():
	set_process(false)

func on_exited():
	queue_free()


func on_coin_body_entered(body):
	if body.is_in_group("bird") and not passed :
		passed = true
		GameManager.UpdateScore.emit()
		animation_player.play("coin")
		await  animation_player.animation_finished
		coin.queue_free()
