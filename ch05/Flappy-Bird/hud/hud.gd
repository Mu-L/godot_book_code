extends CanvasLayer

@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var message = $MarginContainer/VBoxContainer/Message
@onready var button: Button = $MarginContainer/VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()
	GameManager.GameOver.connect(on_game_over)
	GameManager.UpdateScore.connect(update_score)
	button.pressed.connect(on_pressed)
	

func update_score():
	score_label.text = "Score: %s" %str(GameManager.score)

func on_game_over():
	update_score()
	message.text = "GAME OVER"
	message.show()
	button.show()


func on_pressed():
	GameManager.GameStart.emit()
	message.hide()
	button.hide()
	
