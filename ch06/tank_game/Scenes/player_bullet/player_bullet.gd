extends Area2D

@export var speed:float = 100
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready():
	area_entered.connect(on_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(on_screen_exited)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta

func on_area_entered(area:Area2D):
	if area.is_in_group("Enemy"):
		area.reduce_health()
		queue_free()
	

func on_screen_exited():
	queue_free()
