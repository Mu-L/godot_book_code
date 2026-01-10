extends Node2D
class_name Player

var sprite2d_position :Vector2 = Vector2(100,0)
var sprite2d_speed :float = 2*PI
var rotate_numbers :Array = [1,2,3,4,5,6]
var count = rotate_numbers.pick_random()
var start :bool = false
@export var player_speed :float = 2*PI
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.position = sprite2d_position
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += player_speed * delta
	sprite_2d.rotation += sprite2d_speed * delta
	#stop_rotate(count)

func on_pressed() -> void:
	start = not start
	set_process(start)
	
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("click"):
		#start = not start
		#set_process(start)


#func stop_rotate(count:int) -> void:
	#if rotation/(2*PI) > count:
		#print("rotate %s times" %count)
		#set_process(false)
