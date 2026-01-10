extends CharacterBody2D
class_name Player

var direction: Vector2 = Vector2.ZERO
var speed: float = 0
var can_shake := false

@export var max_speed : float = 300
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var weapon_component: Node2D = $WeaponComponent
@onready var trail_compoment: Node2D = $TrailCompoment
@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var camera_2d: Camera2D = $Camera2D
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hurt_box_component.get_damage.connect(health_component.get_damage)
	hurt_box_component.get_damage.connect(on_get_damage)
	health_component.health_changed.connect(on_health_changed)
	health_component.died.connect(on_died)
	Gamemanager.player_win.connect(on_player_win)
	timer.timeout.connect(on_time_out)


func _physics_process(delta: float) -> void:
	move(delta)
	if can_shake:
		shake()
	
func move(delta):
	direction = Input.get_vector("left","right","up","down")
	if direction != Vector2.ZERO:

		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation,angle_rad,2*PI*delta )
		speed = move_toward(speed, max_speed, max_speed*delta)
		trail_compoment.start()
		
	else:
		speed = move_toward(speed, 0, 2*max_speed*delta)
		trail_compoment.stop()
		
	velocity = transform.x * speed 
	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	var target_pos = get_global_mouse_position()
	weapon_component.target(target_pos)
	if event.is_action_pressed("shoot"):
		weapon_component.shoot(target_pos)
	

func on_health_changed(health):
	Gamemanager.update_health_ui.emit(health)
	
	
func on_died():
	Gamemanager.entity_died.emit(global_position,get_groups())
	Gamemanager.player_killed.emit()
	set_physics_process(false)
	hide()
	hurt_box_component.set_deferred("monitorable",false)
	

func upgrade_weapon():
	weapon_component.upgrade(0.1)
	
	
func upgrade_health():
	health_component.upgrade(1)


func on_player_win():
	set_physics_process(false)


func on_get_damage(value):
	animation_player.play("flash")
	can_shake = true
	timer.start()
	

func shake():
	camera_2d.offset = Vector2(randf_range(-3,3),randf_range(-3,3))
	
	
func on_time_out():
	can_shake = false
