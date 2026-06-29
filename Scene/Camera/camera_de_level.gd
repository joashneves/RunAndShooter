extends Camera2D

@export var alvo : CharacterBody2D;
@export var travada : bool = false;

@export var max_shake : float = 2
@export var shake_fade : float = 5
var shake_strength : float = 0

var borda_esquerda;
var borda_direita;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-shake_strength, shake_strength), randf_range(-shake_strength, shake_strength))
	
	if alvo:
		var largura_da_tela = get_viewport_rect().size.x / zoom.x
		var metade_largura = largura_da_tela / 2
		
		# Só avança a câmera se não estiver travada
		if not travada:
			if alvo.global_position.x > global_position.x:
				global_position.x = alvo.global_position.x
				
		borda_esquerda = global_position.x - metade_largura
		borda_direita = global_position.x + metade_largura
		#print(borda_direita, borda_esquerda)
		# Bloqueia o player na borda esquerda para não sair da tela
		if alvo.global_position.x < borda_esquerda:
			alvo.global_position.x = borda_esquerda
			
		# Bloqueia o player na borda direita se a arena estiver ativa (câmera travada)
		if travada and alvo.global_position.x > borda_direita:
			alvo.global_position.x = borda_direita
			
func screen_shake() -> void:
	shake_strength = max_shake
	
