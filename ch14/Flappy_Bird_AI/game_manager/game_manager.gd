extends Node

signal GameOver
signal UpdateScore

var  speed = -150 
const JUMP_VELOCITY = -500.0
const GRAVITY = 1500
const GAP = 180

var score = 0


func _ready():
	UpdateScore.connect(add_score)
	GameOver.connect(on_game_over)
	

func add_score():
	score += 1


func on_game_over():
	score = 0
