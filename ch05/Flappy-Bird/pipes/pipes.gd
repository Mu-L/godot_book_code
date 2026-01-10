extends Node2D


const SPEED = -150 
var passed = false

@onready var coin: Area2D = $Coin
@onready var pipe_bottom: Area2D = $PipeBottom
@onready var pipe_top: Area2D = $PipeTop

@onready var animation_player: AnimationPlayer = $Coin/AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():
	pipe_bottom.body_entered.connect(on_pipe_body_entered)
	pipe_top.body_entered.connect(on_pipe_body_entered)
	coin.body_entered.connect(on_coin_body_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(on_exited)


func _process(delta):
	position.x += delta * SPEED


func on_pipe_body_entered(body):
	if body.is_in_group("bird") and not body.is_dead:
		GameManager.GameOver.emit()
	

func on_exited():
	queue_free()


func on_coin_body_entered(body):
	if body.is_in_group("bird") and not passed :
		passed = true
		GameManager.UpdateScore.emit()
		animation_player.play("coin")
		await  animation_player.animation_finished
		coin.queue_free()
