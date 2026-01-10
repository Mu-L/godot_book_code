extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const GRAVITY = 1500

const HIT = preload("res://assets/hit.wav")
const POINT = preload("res://assets/point.wav")
const WING = preload("res://assets/wing.wav")

var rot_degree = 0
var is_dead = true

@export var max_speed := 700
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cpu_particles_2d = $CPUParticles2D
@onready var fly_sound: AudioStreamPlayer = $FlySound
@onready var score_sound: AudioStreamPlayer = $ScoreSound


func _ready():
	GameManager.GameOver.connect(on_game_over)
	GameManager.UpdateScore.connect(on_get_score)
	GameManager.GameStart.connect(on_game_start)



func _physics_process(delta):
	if not is_dead:
		velocity.y += GRAVITY * delta
		if Input.is_action_just_pressed("fly"):
			velocity.y = JUMP_VELOCITY
			fly_sound.stream = WING
			fly_sound.play()
		rot_degree = clampf(-30 * velocity.y/JUMP_VELOCITY, -30,30)
		rotation_degrees = rot_degree
		velocity.y = clampf(velocity.y, -max_speed, max_speed)
		move_and_slide()



func on_game_start():
	is_dead = false
	cpu_particles_2d.emitting = true


func on_get_score():
	score_sound.stream = POINT
	score_sound.play()
	
	
func on_game_over():
	fly_sound.stream = HIT
	fly_sound.play()
	cpu_particles_2d.emitting = false
	is_dead = true
