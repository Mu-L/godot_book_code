extends Node2D
@onready var button: Button = $Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var child_nodes = get_children()
	for child in child_nodes:
		if child.is_in_group("move"):
			button.pressed.connect(child.on_pressed)
			print("my name is: %s" %child.name)
			print("my position is: %s" %child.position)
			print("my speed is: %s" %child.player_speed)
			print("I have to rotate %s times" %child.count)
