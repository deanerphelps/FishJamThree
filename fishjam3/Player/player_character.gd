extends CharacterBody2D
signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction
var health = Globals.player_health
var enemy_collision_check := false
func _physics_process(delta: float) -> void:
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("ui_left", "ui_right")
		print(direction)
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/2)
		
		move_and_slide()
	
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("Enemy"):
				if direction == 1:
					velocity.x = -2000
				elif direction == -1:
					velocity.x = 2000
				velocity.y = -200
				await get_tree().create_timer(0.1).timeout

		#	print("I collided with ", collision.get_collider().name)
