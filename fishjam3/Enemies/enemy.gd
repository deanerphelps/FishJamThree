extends CharacterBody2D

@export var target_to_chase: CharacterBody2D
@onready var sprite: Node2D = $AnimatedSprite2D
const SPEED = 150.0

func _physics_process(delta: float) -> void:
	if not target_to_chase or not is_inside_tree(): # To prevent the game from crashing
		return

	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	var distance = target_to_chase.global_position.distance_to(global_position)

	# Move toward player if close enough
	if distance <= 200:
		var dir = global_position.direction_to(target_to_chase.global_position).x
		velocity.x = dir * SPEED
		if dir != 0:
			sprite.scale.x = -sign(dir)  # Face the player
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) # Becomes zero but a bit smoother

	move_and_slide()
