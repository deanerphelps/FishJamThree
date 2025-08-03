extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	print(get_gravity())
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor():	
		if direction == 0:
			animated_sprite_2d.play("default")
		elif direction > 0:
			if is_on_floor():
				animated_sprite_2d.scale = Vector2(1,1)
			animated_sprite_2d.play("Running_Right")
		elif direction < 0:
			if is_on_floor():
				animated_sprite_2d.scale = Vector2(-1,1)
			animated_sprite_2d.play("Running_Right")

	move_and_slide()
