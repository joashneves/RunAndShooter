extends Area2D

# Lista de inimigos que podem ser spawnados nesta arena (configure no inspector)
@export var inimigos_scenes : Array[PackedScene]
@export var total_waves : int = 3 
@export var jogador : CharacterBody2D 

var ativo : bool = false
var inimigos_vivos : Array[Node] = []
var camera : Camera2D = null

var wave_atual : int = 0
var esperando_wave : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	if not ativo or esperando_wave:
		return
		
	var todos_mortos : bool = true
	for inimigo in inimigos_vivos:
		if is_instance_valid(inimigo):
			todos_mortos = false
			break
			
	if todos_mortos and inimigos_vivos.size() > 0:
		proxima_wave()

func _on_body_entered(body: Node2D) -> void:
	if ativo:
		return
		
	if body.is_in_group("players"):
		ativo = true
		wave_atual = 0
		travar_camera()
		proxima_wave()

func travar_camera():
	if camera and "travada" in camera:
		camera.travada = true

func liberar_arena():
	if camera and "travada" in camera:
		camera.travada = false
	print("Arena liberada! Você pode prosseguir.")
	queue_free()

func proxima_wave():
	wave_atual += 1
	
	if wave_atual > total_waves:
		liberar_arena()
		return
		
	print("Inimigos_vivos limpos. Iniciando Wave ", wave_atual)
	inimigos_vivos.clear()
	spawnar_inimigos()

func spawnar_inimigos():
	if not jogador:
		print("Inimigos não podem spawnar: Jogador não foi definido!")
		return

	var camera = get_viewport().get_camera_2d()
	if not camera:
		print("Nenhuma câmera ativa encontrada para calcular as bordas!")
		return
		
	var tamanho_tela = get_viewport().get_visible_rect().size
	var centro_camera = tamanho_tela / 2
	
	var x_de_spawn : float = 0.0
	
	if jogador.global_position.x < centro_camera.x:
		x_de_spawn = camera.borda_direita 
	else:
		x_de_spawn = camera.borda_esquerda 
		
	var ponto_de_spawn_base = Vector2(x_de_spawn, jogador.global_position.y)
	
	esperando_wave = true 
	
	# Pega o estado da física para checar colisões no ponto de spawn
	var espaço_fisico = get_world_2d().direct_space_state
	
	for j in range(5):
		var cena_invertida : PackedScene = null
		
		if inimigos_scenes.size() > 0:
			cena_invertida = inimigos_scenes[randi() % inimigos_scenes.size()]
		else:
			cena_invertida = load("res://Scene/Inimigos/Inimigo_x_de_spawnbase/inimigo.tscn")
			
		if cena_invertida:
			var inimigo = cena_invertida.instantiate()
			
			# --- NOVA LÓGICA: CHECAGEM DE INIMIGO VOADOR ---
			# Checa se o script dele tem a variável "is_voador" como true OU se o nome do arquivo tem "voador"
			if ("is_flying" in inimigo and inimigo.is_flying) or "voador" in cena_invertida.resource_path.to_lower():
				# Nasce exatamente no meio horizontal e vertical da tela/câmera calculada
				inimigo.global_position = Vector2(x_de_spawn, jogador.position.y - 64)
				print("Inimigo voador spawnado no centro da tela: ", centro_camera)
			else:
				# --- INIMIGO TERRESTRE / PADRÃO ---
				var posicao_teste = ponto_de_spawn_base
				
				# Loop para empurrar o Y para cima caso o ponto esteja ocupado
				var tentativas = 0
				while tentativas < 10: # Limite de tentativas para evitar loops infinitos
					var parametros_ponto = PhysicsPointQueryParameters2D.new()
					parametros_ponto.position = posicao_teste

					var resultado = espaço_fisico.intersect_point(parametros_ponto)
					
					if resultado.is_empty():
						# Ponto livre encontrado!
						break
					else:
						# Ponto ocupado, joga o Y para cima (subindo na tela)
						posicao_teste.y -= 2 # Ajuste esse valor de pixels com base no tamanho do sprite
						tentativas += 1
						
				inimigo.global_position = posicao_teste
				print("Inimigo terrestre spawnado em: ", posicao_teste)
				
			get_tree().root.add_child(inimigo)
			inimigos_vivos.append(inimigo)
			
	esperando_wave = false
