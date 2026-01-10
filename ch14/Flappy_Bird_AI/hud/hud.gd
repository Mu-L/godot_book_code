extends CanvasLayer

@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	GameManager.GameOver.connect(on_game_over)
	GameManager.UpdateScore.connect(update_score)


func update_score():
	score_label.text = "Score: %s" %str(GameManager.score)

func on_game_over():
	update_score()
