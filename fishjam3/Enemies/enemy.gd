extends CharacterBody2D

@export var target_to_chase: CharacterBody2D
@onready var sprite: Node2D = $AnimatedSprite2D
const SPEED = 150.0
@onready var swipe_collision_shape: CollisionShape2D = $SwipeCollisionShape
@onready var animated_swipe: AnimatedSprite2D = $SwipeCollisionShape/AnimatedSwipe
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

var can_attack := true


func _physics_process(delta: float) -> void:
	if not target_to_chase or not is_inside_tree(): # To prevent the game from crashing
		return

	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	if target_to_chase.is_dashing == true:
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)
	
	
	var distance = target_to_chase.global_position.distance_to(global_position)

	# Move toward player if close enough
	if distance <= 200 and distance > 65:
		var dir = global_position.direction_to(target_to_chase.global_position).x
		velocity.x = dir * SPEED
		if dir != 0:
			sprite.scale.x = -sign(dir)  # Face the player
			
			if dir > 0:
				swipe_collision_shape.scale.x = sign(dir)
				swipe_collision_shape.global_position.x = global_position.x + 34
			else:
				swipe_collision_shape.scale.x = sign(dir)
				swipe_collision_shape.global_position.x = global_position.x - 34


	elif distance <= 75 and target_to_chase.is_dashing == false and can_attack == true: 
		velocity.x = move_toward(velocity.x, 0, SPEED)
		swipe_collision_shape.disabled = false
		animated_swipe.visible = true
		animated_swipe.play("Swipe_Attack")
		can_attack = false
		attack_cooldown_timer.start()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) # Becomes zero but a bit smoother

	move_and_slide()


func _on_animated_swipe_animation_finished() -> void:
	swipe_collision_shape.disabled = true
	animated_swipe.visible = false
	
func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
