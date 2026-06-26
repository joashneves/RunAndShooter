extends Camera2D

@export var alvo : CharacterBody2D;
@export var travada : bool = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if alvo:
		var largura_da_tela = get_viewport_rect().size.x / zoom.x
		var metade_largura = largura_da_tela / 2
		
		# Só avança a câmera se não estiver travada
		if not travada:
			if alvo.global_position.x > global_position.x:
				global_position.x = alvo.global_position.x
				
		var borda_esquerda = global_position.x - metade_largura
		var borda_direita = global_position.x + metade_largura
		
		# Bloqueia o player na borda esquerda para não sair da tela
		if alvo.global_position.x < borda_esquerda:
			alvo.global_position.x = borda_esquerda
			
		# Bloqueia o player na borda direita se a arena estiver ativa (câmera travada)
		if travada and alvo.global_position.x > borda_direita:
			alvo.global_position.x = borda_direita
