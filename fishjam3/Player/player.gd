extends CharacterBody2D
signal hit
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_label: Label = $HealthLabel
@onready var swipe_attack: Area2D = $SwipeAttack
@onready var dash_timer: Timer = $DashTimer
@onready var knockback_lock_timer: Timer = $KnockbackLockTimer


const SPEED = 300.0
const DASH_SPEED = 2500.0
const JUMP_VELOCITY = -400.0
var direction
var max_health = Globals.player_health
var health = max_health
var enemy_collision_check := false
var is_dashing := false
var last_direction

func _ready() -> void:
	health_label.text = str(health)+"/"+str(max_health)
func _physics_process(delta: float) -> void:
	health_label.text = str(health)+"/"+str(max_health)
	
	if direction != 0:
		last_direction = direction
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("default")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && is_on_floor() && not enemy_collision_check:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction && not enemy_collision_check && not is_dashing:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() && not is_dashing:	
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
	
	dash()
#Assuming the number of collisions is > 0, check if the last collision happened (this part would break if there was no last collision), then do the knockback
	if get_slide_collision_count()>0:
		if(get_last_slide_collision().get_collider().is_in_group("Enemy")):
			var enemy = get_last_slide_collision().get_collider()
			emit_signal("hit")
			knockback_lock_timer.start()
			enemy_collision_check = true
			if enemy.global_position.x > global_position.x:
				velocity.x = -2000
			elif enemy.global_position.x < global_position.x:
				velocity.x = 2000
			velocity.y = -200
				#await get_tree().create_timer(0.4).timeout

	move_and_slide()

	if direction == -1: #&& animated_swipe.is_playing() == false:
		swipe_attack.scale = Vector2(-1, 1)
		swipe_attack.position = Vector2(-32, 0)
	elif direction == 1: #&& animated_swipe.is_playing() == false:
		swipe_attack.scale = Vector2(1, 1)
		swipe_attack.position = Vector2(32, 0)

func _on_hit() -> void:
	if enemy_collision_check == false:
		health = health-1
	if health <= 0:
		get_tree().change_scene_to_file("res://MainMenu.tscn")

func dash():
	if Input.is_action_just_pressed("Dash") && not is_dashing:
		is_dashing = true
		dash_timer.start()
		animated_sprite_2d.material.blend_mode = 4
		if last_direction != null:
			if last_direction > 0 || direction > 0:
				velocity.x = DASH_SPEED
				animated_sprite_2d.play("Dash")
			elif last_direction < 0 || direction < 0:
				velocity.x = -DASH_SPEED
				animated_sprite_2d.scale = Vector2(-1,1)
				animated_sprite_2d.play("Dash")
		else:
			is_dashing = false
		


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	animated_sprite_2d.material.blend_mode = 0


func _on_knockback_lock_timer_timeout() -> void:
	enemy_collision_check = false
