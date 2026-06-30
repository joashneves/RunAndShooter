extends CharacterBody2D
class_name Inimigo_base


# Configurações básicas de movimento
@export var velocidade : float = 50.0
@export var projetil : PackedScene

# Configurações de Vida
@export var vida : int = 1:
	set(value):
		if value < vida:
			piscar_vermelho()
		vida = value
		verifica_vida()

# Configurações de comportamento da IA
@export var pode_pular : bool = true
@export var velocidade_do_pulo : float = -180.0
@export var recua_do_player : bool = true
@export var distancia_recuo : float = 60.0
@export var ataque_a_distancia : bool = true
@export var distancia_ataque : float = 160.0
@export var tempo_recarga_ataque : float = 1.5
@export var persegue_player : bool = false
@export var is_flying : bool = false
@export var mira_no_player : bool = false

# Configurações de Despawn e Foco
@export var limite_queda_y : float = 600.0
@export var distancia_perda_foco : float = 250.0

var status : Array = ["pensando", "movendo", "atacando", "recuando"]
var status_atual : String = "movendo"

var velocidade_maxima : float = velocidade
var inimigo_na_tela : bool = false
var direcao : Vector2 = Vector2.LEFT
var tempo_recarga_atual : float = 0.0
var tempo_preso_na_parede : float = 0.0

@onready var player : Player = get_tree().get_first_node_in_group("players")
@onready var camera : Camera2D = get_tree().get_first_node_in_group("camera")
const PARTICULA_DANO = preload("uid://co2acc3hsip1t")

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	velocidade_maxima = velocidade
	if player:
		if player.position.x < position.x:
			direcao = Vector2.LEFT
		elif player.position.x > position.x:
			direcao = Vector2.RIGHT
		atualizar_visual()

func _process(delta: float) -> void:
	if not inimigo_na_tela: return
	verifica_vida()

func _physics_process(delta: float) -> void:
	if not inimigo_na_tela: return
	
	# Despawn se cair no abismo
	if global_position.y > limite_queda_y:
		queue_free()
		return
		
	# Atualiza tempo de recarga de ataque
	tempo_recarga_atual += delta
	
	# Gerencia foco no player e decide o estado da IA com histerese (margem de segurança)
	if player and is_instance_valid(player) and player.esta_vivo:
		var dist = global_position.distance_to(player.global_position)
		
		if dist > distancia_perda_foco:
			player = null
			status_atual = "movendo"
		else:
			# Decidir ação com base na distância usando Histerese
			if status_atual == "recuando":
				if dist > distancia_recuo + 20.0:
					status_atual = "atacando" if ataque_a_distancia else "movendo"
			elif status_atual == "atacando":
				if dist < distancia_recuo:
					status_atual = "recuando" if recua_do_player else "atacando"
				elif dist > distancia_ataque + 30.0:
					status_atual = "movendo"
			else: # "movendo"
				if dist < distancia_recuo and recua_do_player:
					status_atual = "recuando"
				elif dist < distancia_ataque and ataque_a_distancia:
					status_atual = "atacando"
	else:
		player = null
		status_atual = "movendo"
		
	match status_atual:
		"pensando":
			pass
		"movendo":
			movimento_inimigo(delta)
			check_camera_boundaries()
		"recuando":
			movimento_recuo(delta)
			check_camera_boundaries()
		"atacando":
			movimento_ataque(delta)
			check_camera_boundaries()
			if tempo_recarga_atual >= tempo_recarga_ataque:
				atacar_player()
				tempo_recarga_atual = 0.0

func atacar_player():
	if not projetil: return
	print("atirando")
	var tiro = projetil.instantiate()
	tiro.global_position = global_position
	
	# Define a direção do tiro
	if mira_no_player and player and is_instance_valid(player):
		tiro.direcao = (player.global_position - global_position).normalized()
		tiro.rotation = tiro.direcao.angle()
	else:
		tiro.direcao = direcao
		
	get_tree().root.add_child(tiro)

func movimento_inimigo(delta):
	if not is_flying:
		# Inimigos terrestres (aplicam gravidade)
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# CORREÇÃO: Removeu o 'and not is_on_wall()' para permitir que mude de direção se o player pular por cima dele
		if player and is_instance_valid(player) and persegue_player:
			var dir_player = (player.global_position - global_position).normalized()
			direcao.x = sign(dir_player.x)
			if direcao.x == 0:
				direcao.x = 1
			atualizar_visual()
			
		velocity.x = direcao.x * velocidade
		move_and_slide()
		
		# Pula obstáculos se bater em paredes
		if is_on_wall():
			if is_on_floor() and pode_pular:
				velocity.y = velocidade_do_pulo
			else:
				tempo_preso_na_parede += delta
				if tempo_preso_na_parede > 0.15:
					flip()
					tempo_preso_na_parede = 0.0
					# Afasta um pouco da parede para não re-colidir no mesmo frame
					global_position.x += direcao.x * 2.0 
		else:
			tempo_preso_na_parede = 0.0
	else:
		# Inimigos voadores (não aplicam gravidade)
		if player and is_instance_valid(player) and persegue_player:
			var dir_player = (player.global_position - global_position).normalized()
			direcao.x = sign(dir_player.x)
			if direcao.x == 0:
				direcao.x = 1
			atualizar_visual()
			
		velocity.x = direcao.x * velocidade
		move_and_slide()
		if is_on_wall():
			flip()
			global_position.x += direcao.x * 2.0

func movimento_recuo(delta):
	if player and is_instance_valid(player):
		var dir_player = (player.global_position - global_position).normalized()
		direcao.x = -sign(dir_player.x) # direção oposta
		if direcao.x == 0:
			direcao.x = -1
		atualizar_visual()
		
		if not is_flying:
			if not is_on_floor():
				velocity.y += gravity * delta
				
			velocity.x = direcao.x * (velocidade * 1.2) # corre mais rápido
			move_and_slide()
			
			if is_on_wall():
				if is_on_floor() and pode_pular:
					velocity.y = velocidade_do_pulo
				else:
					tempo_preso_na_parede += delta
					if tempo_preso_na_parede > 0.15:
						flip()
						tempo_preso_na_parede = 0.0
						global_position.x += direcao.x * 2.0
			else:
				tempo_preso_na_parede = 0.0
		else:
			velocity.x = direcao.x * (velocidade * 1.2)
			move_and_slide()
			if is_on_wall():
				flip()
				global_position.x += direcao.x * 2.0

func movimento_ataque(delta):
	if player and is_instance_valid(player):
		var dir_player = (player.global_position - global_position).normalized()
		direcao.x = sign(dir_player.x) # vira de frente para o player
		if direcao.x == 0:
			direcao.x = 1
		atualizar_visual()
		
		if not is_flying:
			if not is_on_floor():
				velocity.y += gravity * delta
				
			velocity.x = direcao.x * (velocidade * 0.4) # aproximação lenta
			move_and_slide()
			
			if is_on_wall():
				if is_on_floor() and pode_pular:
					velocity.y = velocidade_do_pulo
				else:
					tempo_preso_na_parede += delta
					if tempo_preso_na_parede > 0.15:
						flip()
						tempo_preso_na_parede = 0.0
						global_position.x += direcao.x * 2.0
			else:
				tempo_preso_na_parede = 0.0
		else:
			velocity.x = direcao.x * (velocidade * 0.4)
			move_and_slide()
			if is_on_wall():
				flip()
				global_position.x += direcao.x * 2.0

func flip():
	direcao.x *= -1
	atualizar_visual()

func atualizar_visual():
	var sprite = get_node_or_null("AnimatedSprite2D")
	if sprite:
		sprite.flip_h = (direcao.x < 0)
	
	var area_hit = get_node_or_null("AreaDeHit")
	if area_hit:
		area_hit.position.x = abs(area_hit.position.x) * direcao.x

func check_camera_boundaries():
	var cam = get_viewport().get_camera_2d()
	if cam:
		var largura_da_tela = get_viewport_rect().size.x / cam.zoom.x
		var borda_esquerda = cam.global_position.x - (largura_da_tela / 2)
		var borda_direita = cam.global_position.x + (largura_da_tela / 2)
		
		if global_position.x < borda_esquerda - 150:
			queue_free()
			return
			
		if global_position.x <= borda_esquerda and direcao.x < 0:
			flip()
			global_position.x += direcao.x * 2.0
		elif global_position.x >= borda_direita and direcao.x > 0:
			flip()
			global_position.x += direcao.x * 2.0
	
func verifica_vida():
	if vida <= 0:
		GameManager.pontos += 10;
		GameManager.hitStop()
		AudioManager.tocar_som_hit()
		queue_free()
		

func piscar_vermelho():
	var sprite = get_node_or_null("AnimatedSprite2D")
	camera.screen_shake()
	if sprite:
		sprite.modulate = Color(2.5, 0.4, 0.4, 1.0)
		await get_tree().create_timer(0.15).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	inimigo_na_tela = true

func _on_area_de_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		velocidade = 0
		body.morte()

func _on_area_de_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player = body
		if not ataque_a_distancia:
			atacar_player()
