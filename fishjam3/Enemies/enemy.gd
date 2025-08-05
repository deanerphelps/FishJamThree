extends CharacterBody2D

@export var target_to_chase: CharacterBody2D
const SPEED = 150.0
var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if target_to_chase.global_position.distance_to(global_position) <= 200:
		velocity.x = global_position.direction_to(target_to_chase.global_position).x * SPEED
	else:
		velocity.x = 0
	move_and_slide()
