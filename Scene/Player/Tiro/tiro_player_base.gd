extends Area2D

@export var velocidade_da_bala : float = 200
@export var direcao : Vector2 = Vector2.RIGHT

const PARTICULA_DANO = preload("uid://co2acc3hsip1t")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.frame = randi_range(0,3)
	if direcao == Vector2.ZERO:
		direcao = Vector2.RIGHT

func _process(delta: float) -> void:
	position += direcao * velocidade_da_bala * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		body.vida -= 1
		spawnar_efeito_impacto() # <-- Cria a partícula no inimigo
		queue_free()
		
	if body is TileMap or body is TileMapLayer:
		spawnar_efeito_impacto() # <-- Cria a partícula na parede
		queue_free()

# Função isolada para criar o efeito exatamente onde a bala bateu
func spawnar_efeito_impacto():
	if PARTICULA_DANO:
		var particula = PARTICULA_DANO.instantiate()
		particula.global_position = global_position # Pega a posição atual da bala no impacto	
		particula.rotation = rotation
			
		get_tree().root.add_child(particula)
