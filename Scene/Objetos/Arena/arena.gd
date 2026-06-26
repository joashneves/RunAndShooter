extends Area2D

# Lista de inimigos que podem ser spawnados nesta arena (configure no inspector)
@export var inimigos_scenes : Array[PackedScene]

var ativo : bool = false
var inimigos_vivos : Array[Node] = []
var camera : Camera2D = null

func _ready() -> void:
	# Conecta o sinal de entrada de corpos
	body_entered.connect(_on_body_entered)
	camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	if not ativo:
		return
		
	# Verifica se todos os inimigos spawnados já foram derrotados
	var todos_mortos : bool = true
	for inimigo in inimigos_vivos:
		if is_instance_valid(inimigo):
			todos_mortos = false
			break
			
	if todos_mortos:
		liberar_arena()

func _on_body_entered(body: Node2D) -> void:
	if ativo:
		return
		
	# Quando o player entra na área de gatilho, a arena começa
	if body.is_in_group("players"):
		ativo = true
		travar_camera()
		spawnar_inimigos()

func travar_camera():
	if camera and "travada" in camera:
		camera.travada = true

func liberar_arena():
	if camera and "travada" in camera:
		camera.travada = false
	print("Arena liberada! Você pode prosseguir.")
	queue_free()

func spawnar_inimigos():
	# Busca todos os nós Marker2D que são filhos diretos desta arena
	var markers : Array = []
	for child in get_children():
		if child is Marker2D:
			markers.append(child)
			
	if markers.size() == 0:
		print("Nenhum Marker2D filho encontrado para spawnar inimigos!")
		liberar_arena()
		return
		
	# Spawna um inimigo em cada marker encontrado
	for marker in markers:
		var cena_inimigo : PackedScene = null
		
		# Se o usuário configurou cenas no Inspector, escolhe uma aleatória
		if inimigos_scenes.size() > 0:
			cena_inimigo = inimigos_scenes[randi() % inimigos_scenes.size()]
		else:
			# Fallback caso não tenha configurado nenhuma cena
			cena_inimigo = load("res://Scene/Inimigos/Inimigo_base/inimigo.tscn")
			
		if cena_inimigo:
			var inimigo = cena_inimigo.instantiate()
			inimigo.global_position = marker.global_position
			get_tree().root.add_child(inimigo)
			inimigos_vivos.append(inimigo)
