extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("default")
	# Conecta o sinal para detectar quando inimigos entrarem na explosão
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		body.vida -= 1
		print("Explosão atingiu inimigo: ", body.name)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
