extends CharacterBody2D
signal hit
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_label: Label = $HealthLabel
@onready var swipe_attack: Area2D = $SwipeAttack


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction
var max_health = Globals.player_health
var health = max_health
var enemy_collision_check := false

func _ready() -> void:
	health_label.text = str(health)+"/"+str(max_health)
func _physics_process(delta: float) -> void:
	health_label.text = str(health)+"/"+str(max_health)
	 #Commented Duplicate Movement, sorry Paisley :(
	#var x_input = Input.get_axis("ui_left", "ui_right")
	#velocity.x = x_input * SPEED
	#
	#move_and_slide()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction && not enemy_collision_check:
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

#Assuming the number of collisions is > 0, check if the last collision happened (this part would break if there was no last collision), then do the knockback
	if get_slide_collision_count()>0:
		if(get_last_slide_collision().get_collider().is_in_group("Enemy")):
						
			enemy_collision_check = true
			emit_signal("hit")
			if direction == 1:
				velocity.x = -2000
			elif direction == -1:
				velocity.x = 2000
			velocity.y = -200
			if health > 0:
				await get_tree().create_timer(0.4).timeout
				enemy_collision_check = false

	if direction == -1: #&& animated_swipe.is_playing() == false:
		swipe_attack.scale = Vector2(-1, 1)
		swipe_attack.position = Vector2(-32, 0)
	elif direction == 1: #&& animated_swipe.is_playing() == false:
		swipe_attack.scale = Vector2(1, 1)
		swipe_attack.position = Vector2(32, 0)


func _on_hit() -> void:
	health = health-1
	if health <= 0:
		get_tree().reload_current_scene()
