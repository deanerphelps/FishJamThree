extends Area2D

@export var get_player: CharacterBody2D
@export var move_speed:= 200
@onready var spear_area: Area2D = $SpearArea
@onready var sword_area: Area2D = $SwordArea
@onready var spear_collision_right: CollisionShape2D = $SpearArea/SpearCollisionRight
@onready var spear_collision_left: CollisionShape2D = $SpearArea/SpearCollisionLeft
@onready var attack_duration_timer: Timer = $AttackDurationTimer


var attack_check = false
var is_attacking = false
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = get_player.get_global_position()
	global_position.x = move_toward(global_position.x, player_position.x, move_speed*delta)



func spear_attack():
	print("Spear Attack!")
	spear_area.set_collision_layer(4)
	spear_area.rotation = -45.0


	
func sword_attack():
	print("Sword Attack!")
	
func _on_attack_timer_timeout() -> void:
	var distance = get_player.global_position.distance_to(global_position)
	if is_attacking == false && distance <= 100:
		is_attacking = true
		var attack_choice = randf()
		var attack = randf()
		if attack > 0.47:
			attack_duration_timer.start()
			if attack_choice > 0.5:
				spear_attack()
			elif attack_choice < 0.5:
				sword_attack()
		else:
			is_attacking = false

func _on_attack_duration_timer_timeout() -> void:
	is_attacking = false
	if spear_area.rotation != 0:
		spear_area.rotation = 0
