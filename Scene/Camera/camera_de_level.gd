extends Camera2D

@export var alvo : CharacterBody2D;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alvo:
		if alvo.global_position.x > global_position.x:
			global_position.x = alvo.global_position.x
			
		var largura_da_tela = get_viewport_rect().size.x / zoom.x
		var borda_esquerda = global_position.x - (largura_da_tela / 2)
		
		if alvo.global_position.x < borda_esquerda:
			alvo.global_position.x = borda_esquerda
