extends CharacterBody2D

signal hit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_label: Label = $HealthLabel
@onready var swipe_attack: Area2D = $SwipeAttack
@onready var input_menu: Control = $GUI/InputSettings
@onready var dash_timer: Timer = $DashTimer
@onready var knockback_lock_timer: Timer = $KnockbackLockTimer
@onready var blinking_timer: Timer = $BlinkingTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

const SPEED = 300.0
const DASH_SPEED = 2500.0
const JUMP_VELOCITY = -400.0
const KNOCKBACK_FORCE_X = 2000
const KNOCKBACK_FORCE_Y = -200

var direction := 0
var last_direction := 1
var is_dashing := false
var enemy_collision_check := false
var is_invincible := false
var can_dash := true
var has_air_dashed := false
var was_on_floor := false


var max_health := Globals.player_health
var health := max_health

func _ready() -> void:
	update_health_label()

func _physics_process(delta: float) -> void:
	update_health_label()
	remap_menu()

	direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		last_direction = direction

	handle_gravity(delta)
	handle_jump()
	handle_movement()
	handle_dash()
	handle_animation()
	handle_collisions()
	update_swipe_attack_position()

	move_and_slide()


	if is_on_floor() and not was_on_floor:
		has_air_dashed = false
	was_on_floor = is_on_floor()


func handle_gravity(delta: float) -> void:
	#disable this for some shenanigans
	if is_dashing == false:
		if not is_on_floor():
			velocity += get_gravity() * delta

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor() and not enemy_collision_check:
		velocity.y = JUMP_VELOCITY

func handle_movement() -> void:
	if direction and not enemy_collision_check and not is_dashing:
		velocity.x = direction * SPEED
	elif not is_dashing:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_dash() -> void:
	if Input.is_action_just_pressed("dash") and not is_dashing and can_dash:
		if not is_on_floor() and has_air_dashed:
			return  # Prevent second air dash

		is_dashing = true
		can_dash = false
		set_collision_mask_value(4, false)
		
		dash_timer.start()
		dash_cooldown_timer.start()
		animated_sprite_2d.material.blend_mode = 4

		var dash_dir = last_direction
		velocity.x = dash_dir * DASH_SPEED
		animated_sprite_2d.scale.x = dash_dir
		animated_sprite_2d.play("dash")

		if not is_on_floor():
			has_air_dashed = true


func handle_animation() -> void:
	if is_dashing:
		return

	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("default") # Add jumping animation here later
		else:
			animated_sprite_2d.play("default") # Add falling animation here later
	elif direction == 0:
		animated_sprite_2d.play("default")
	else:
		animated_sprite_2d.scale.x = last_direction
		animated_sprite_2d.play("running") # No need for two running animations

func handle_collisions() -> void:
	if enemy_collision_check:
		return

	for i in range(get_slide_collision_count()): # Loop over all collisions
		var collision = get_slide_collision(i) # Store a specific one
		var enemy = collision.get_collider() # Detect the collider object
		if enemy and enemy.is_in_group("Enemy"): # Hit logic if enemy
			emit_signal("hit")
			enemy_collision_check = true
			knockback_lock_timer.start()

			if enemy.global_position.x > global_position.x:
				velocity.x = -KNOCKBACK_FORCE_X
			else:
				velocity.x = KNOCKBACK_FORCE_X

			velocity.y = KNOCKBACK_FORCE_Y
			
			# Invincibility blinking
			is_invincible = true
			blinking_timer.start()
			
			break

func update_swipe_attack_position() -> void:
	swipe_attack.scale.x = last_direction
	swipe_attack.position.x = 32 * last_direction
	swipe_attack.position.y = 0 # Future handling

func update_health_label() -> void:
	health_label.text = str(health) + "/" + str(max_health)

func remap_menu() -> void:
	if Input.is_action_just_pressed("remap_menu"):
		if not input_menu.visible:
			input_menu.visible = true
		else:
			input_menu.visible = false

func _on_hit() -> void:
	if not enemy_collision_check:
		health -= 1
		update_health_label()

	if health <= 0:
		get_tree().change_scene_to_file("res://UI/MainMenu.tscn")

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	set_collision_mask_value(4, true)
	animated_sprite_2d.material.blend_mode = 0

func _on_knockback_lock_timer_timeout() -> void:
	enemy_collision_check = false
	

func _on_blinking_timer_timeout() -> void:
	if not is_invincible:
		return
	
	if animated_sprite_2d.modulate.a == 1.0:
		animated_sprite_2d.modulate.a = 0.3
	else:
		animated_sprite_2d.modulate.a = 1.0
	
	# Repeat until duration ends
	if enemy_collision_check:
		blinking_timer.start()
	else:
		animated_sprite_2d.modulate.a = 1.0
		is_invincible = false

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
