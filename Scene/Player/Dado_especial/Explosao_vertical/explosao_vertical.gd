extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:

	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("default")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
