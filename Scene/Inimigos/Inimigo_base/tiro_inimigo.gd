extends Area2D

@export var velocidade_da_bala : float = 100;
@export var direcao : Vector2 = Vector2.RIGHT;

func _ready() -> void:
	
	if direcao == Vector2.ZERO:
		direcao = Vector2.RIGHT

func _process(delta: float) -> void:
	position += direcao * velocidade_da_bala * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	print("Sumi!")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is TileMap or body is TileMapLayer:
		queue_free()
