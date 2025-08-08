extends Area2D

@export var get_player: CharacterBody2D
@export var move_speed:= 200.0
@onready var spear_area: Area2D = $SpearArea
@onready var sword_area: Area2D = $SwordArea

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = get_player.get_global_position()
	global_position.x = move_toward(global_position.x, player_position.x, move_speed)
