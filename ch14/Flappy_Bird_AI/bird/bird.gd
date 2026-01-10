extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var cpu_particles_2d = $CPUParticles2D
@onready var fly_sound: AudioStreamPlayer = $FlySound
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var sensors: Node2D = $Sensors


@onready var ai_controller = $AIController

@export var max_speed := 700
# Get the gravity from the project settings to be synced with RigidBody nodes.
var rot_degree = 0
var is_dead = false

const HIT = preload("res://assets/hit.wav")
const POINT = preload("res://assets/point.wav")
const WING = preload("res://assets/wing.wav")


func _ready():
	GameManager.GameOver.connect(on_game_over)
	GameManager.UpdateScore.connect(on_get_score)
	ai_controller.init(self)

	

func _physics_process(delta):

	if not is_dead:
		ai_controller.reward += 0.01
		velocity.y += GameManager.GRAVITY * delta

		if ai_controller.heuristic == "human":
			if Input.is_action_just_pressed("fly"):
				velocity.y = GameManager.JUMP_VELOCITY
				fly_sound.stream = WING
				fly_sound.play()
			rot_degree = clampf(-30 * velocity.y/GameManager.JUMP_VELOCITY, -30,30)
			animated_sprite_2d.rotation_degrees = rot_degree
		else:
			var action = ai_controller.move_action
			if action == 1:
				velocity.y = GameManager.JUMP_VELOCITY
				fly_sound.stream = WING
				fly_sound.play()
			rot_degree = clampf(-30 * velocity.y/GameManager.JUMP_VELOCITY, -30,30)
			animated_sprite_2d.rotation_degrees = rot_degree
		velocity.y = clampf(velocity.y, -max_speed, max_speed)
		move_and_slide()

func on_game_over():

	ai_controller.reward -= 5
	ai_controller.done = true
	ai_controller.reset()

func on_get_score():
	ai_controller.reward += 1
	score_sound.stream = POINT
	score_sound.play()
	
