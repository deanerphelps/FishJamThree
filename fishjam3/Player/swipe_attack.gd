extends Area2D
@onready var animated_swipe: AnimatedSprite2D = $AnimatedSwipe

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	collision_shape_2d.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		visible = true
		collision_shape_2d.disabled = false
		print("Attack")
		animated_swipe.play("Swipe_Attack")
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	collision_shape_2d.disabled = true
	visible = false
