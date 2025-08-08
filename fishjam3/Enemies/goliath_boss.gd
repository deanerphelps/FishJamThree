extends Area2D

@export var get_player: CharacterBody2D
@export var move_speed:= 200
@onready var spear_area: Area2D = $SpearArea
@onready var sword_area: Area2D = $SwordArea

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
	var player_position = get_player.get_global_position()
	# gets the angle we want to face
	var angle_to_player = global_position.direction_to(player_position).angle()
	
	# slowly changes the rotation to face the angle
	spear_area.rotation = move_toward(rotation, angle_to_player, 1)
	
	#spear_area.global_position.x = move_toward(spear_area.global_position.x, player_position.x, 50)
	#spear_area.global_position.y = move_toward(spear_area.global_position.y, player_position.x, 50)
	is_attacking = false
	
func sword_attack():
	print("Sword Attack!")
	is_attacking = false
func _on_attack_timer_timeout() -> void:
	var distance = get_player.global_position.distance_to(global_position)
	if is_attacking == false && distance <= 100:
		is_attacking = true
		var attack_choice = randf()
		var attack = randf()
		if attack > 0.47:
			if attack_choice > 0.5:
				spear_attack()
			elif attack_choice < 0.5:
				sword_attack()
		else:
			is_attacking = false
