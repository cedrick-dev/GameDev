extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false

func _ready():
	# Connect the animation_finished signal once
	sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	if not is_attacking:
		if (velocity.x > 1 || velocity.x < -1):
			sprite_2d.animation = "running"
		else:
			sprite_2d.animation = "default"

		if not is_on_floor():
			velocity.y += gravity * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 15)

		move_and_slide()

		var isLeft = velocity.x < 0
		sprite_2d.flip_h = isLeft

		if Input.is_action_just_pressed("attack"):
			attack()
	else:
		# Let animation play without input
		velocity.x = move_toward(velocity.x, 0, 15)
		move_and_slide()

func attack():
	if not is_attacking:
		is_attacking = true
		sprite_2d.animation = "attack"
		sprite_2d.play()

func _on_animation_finished():
	if sprite_2d.animation == "attack":
		is_attacking = false
