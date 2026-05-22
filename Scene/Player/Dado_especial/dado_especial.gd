extends Area2D

@export var velocidade_da_bala : float = 200;
@export var direcao : Vector2 = Vector2.RIGHT;
@export var forca_do_pulo : float = -200
var velocity : Vector2 = Vector2.ZERO
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const EXPLOSAO_VERTICAL = preload("uid://wgq4wtteqveg")

var ultima_posicao = global_position
func _ready() -> void:
	velocity.x = direcao.x * velocidade_da_bala
	velocity.y = forca_do_pulo

	if direcao == Vector2.ZERO:
		direcao = Vector2.RIGHT
	

func _process(delta: float) -> void:
	velocity.y += gravity * delta
	position += velocity * delta
	animated_sprite_2d.rotation += 10 * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigos"):
		criar_explocao()
		body.vida -= 1;
		ultima_posicao = global_position
		queue_free()
	if body is TileMap or body is TileMapLayer:
		criar_explocao()
		ultima_posicao = global_position
		queue_free()
	
func criar_explocao():
	var explosao_vertical = EXPLOSAO_VERTICAL.instantiate()
	explosao_vertical.global_position = global_position - Vector2(0, 16)
	get_tree().root.add_child(explosao_vertical)

		
