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
	is_attacking = false
	
func sword_attack():
	print("Sword Attack!")
	is_attacking = false
func _on_attack_timer_timeout() -> void:
	if is_attacking == false:
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
