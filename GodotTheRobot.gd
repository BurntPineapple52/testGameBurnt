extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
var BOUNCE_VELOCITY = -1000.0
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
var grounded = false

var flipx = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_player.set_default_blend_time(.2)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if grounded:
			grounded = false
	
	if !grounded and is_on_floor():
		grounded = true
		print("land")
		animation_player.play("on_land")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x != 0 and is_on_floor():
		if velocity.x > 0:
			animation_player.play("walk_r")
		else:
			animation_player.play("walk_l")
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")

	move_and_slide()


func _on_red_enemy_hitbox_body_entered(body):
	if body == self:
		get_tree().reload_current_scene()
	#then send to spawn


func _on_bounce_pad_body_entered(body):
	if body == self:
		velocity.y = BOUNCE_VELOCITY
		animation_player.play("bouncepad_launch")
		print("bounce")
