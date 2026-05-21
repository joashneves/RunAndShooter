extends CharacterBody2D
class_name Player
@export var velocidade : float = 50;
@export var velocidade_do_pulo : float = -200;
@export var esta_vivo : bool = false;

@onready var animacao_player: AnimatedSprite2D = $AnimacaoPlayer
@onready var colisao_player_normal: CollisionShape2D = $ColisaoPlayerNormal
@onready var colisao_player_deitado: CollisionShape2D = $ColisaoPlayerDeitado
@onready var colisao_area_player: CollisionShape2D = $Player_colisao_com_projetil/ColisaoAreaPlayer

# movimento
var esta_deitado : bool = false
var movimento_horizontal = Vector2.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direcao_visao_var : Vector2 = Vector2.ZERO

# Tiro
const TIRO_PLAYER_BASE = preload("uid://d1xy77uo40bm0")

@onready var tiro_em_pe_marker: Marker2D = $Tiro_em_pe
@onready var tiro_deitado_marker: Marker2D = $Tiro_deitado

var tiro_marker : Marker2D = tiro_deitado_marker

var tempo_de_tiro : float = 1;
var tempo_de_tiro_padrao : float = tempo_de_tiro
var tempo_de_tiro_atual : float = tempo_de_tiro;

## Var upgrade de tiro 1
var buff_de_metralhadora : float = 0
var buff_de_metralhadora_municao: int = 0
var buff_de_metralhadora_max : float = 10

func _process(delta: float) -> void:
	se_estiver_deitado()
	animacao_tocando()
	atirar(delta)
	gerenciar_buffs(delta)
		
func _physics_process(delta: float) -> void:
	direcao_visao()
	movimento(delta)
	
	
func atirar(delta):
	tempo_de_tiro_atual += delta
	if Input.is_action_just_pressed("atira") and tempo_de_tiro_atual >= tempo_de_tiro:

		if buff_de_metralhadora_municao > 0:
			buff_de_tiro_metralhadora(delta)
		else:
			tiro_normal(delta)
			
		tempo_de_tiro_atual = 0

func tiro_normal(delta):
	var tiro = TIRO_PLAYER_BASE.instantiate()
	tiro.global_position = tiro_marker.global_position
	tiro.direcao = direcao_visao_var
	get_tree().root.add_child(tiro)
	

func buff_de_tiro_metralhadora(delta):
	var tiro = TIRO_PLAYER_BASE.instantiate()
	tiro.global_position = tiro_marker.global_position
	tiro.direcao = direcao_visao_var
	get_tree().root.add_child(tiro)
	
	buff_de_metralhadora_municao -= 1
	
func gerenciar_buffs(delta):
	if buff_de_metralhadora_municao > 0:
		tempo_de_tiro = 0.1
	else:
		tempo_de_tiro = tempo_de_tiro_padrao

func movimento(delta : float):
	
	movimento_horizontal.x = Input.get_action_strength("tecla_direita") - Input.get_action_strength("tecla_esquerda");

	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if  Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = velocidade_do_pulo
		
	movimento_horizontal = movimento_horizontal.normalized()
	position += movimento_horizontal * velocidade * delta
		
	move_and_slide()

func direcao_visao():
	if Input.is_action_just_pressed("tecla_direita"):
		direcao_visao_var = Vector2.RIGHT
	elif Input.is_action_just_pressed("tecla_esquerda"):
		direcao_visao_var = Vector2.LEFT
	elif Input.is_action_just_pressed("tecla_cima"):
		direcao_visao_var = Vector2.UP
	if Input.get_action_strength("tecla_baixo"):
		esta_deitado = true
	else:
		esta_deitado = false


func se_estiver_deitado():
	if esta_deitado:
		colisao_player_normal.disabled = true
		colisao_player_deitado.disabled = false
		velocidade = 10;
		tiro_marker = tiro_deitado_marker
	elif esta_deitado == false:
		colisao_player_normal.disabled = false
		colisao_player_deitado.disabled = true
		velocidade = 50
		tiro_marker = tiro_em_pe_marker
	
	if movimento_horizontal != Vector2.ZERO:
			animacao_player.scale.x = movimento_horizontal.x
			tiro_deitado_marker.position.x = tiro_deitado_marker.position.x * animacao_player.scale.x 
			tiro_em_pe_marker.position.x = tiro_em_pe_marker.position.x * animacao_player.scale.x 
			
func animacao_tocando():
	# Animacao de agachado
	if movimento_horizontal != Vector2.ZERO:
		if Input.get_action_strength("tecla_baixo") and is_on_floor():
			animacao_player.play("player_andando_deitado")
		else:
			animacao_player.play("player_andando_em_pe")
	elif movimento_horizontal == Vector2.ZERO:
		if Input.get_action_strength("tecla_baixo") and is_on_floor():
			animacao_player.play("default_deitado")
		else:
			animacao_player.play("default")

func _on_player_colisao_com_projetil_area_entered(area: Area2D) -> void:
	if area.is_in_group("inimigo_tiro"):
		area.queue_free()
		get_tree().reload_current_scene()
