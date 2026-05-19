extends CharacterBody2D
class_name Player
@export var velocidade : float = 100;
@export var velocidade_do_pulo : float = -200;
@export var esta_vivo : bool = false;

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direcao_visao_var : Vector2 = Vector2.ZERO

const TIRO_PLAYER_BASE = preload("uid://d1xy77uo40bm0")
var tempo_de_tiro : float = 1;
var tempo_de_tiro_padrao : float = tempo_de_tiro
var tempo_de_tiro_atual : float = tempo_de_tiro;

## Var upgrade de tiro 1
var buff_de_metralhadora : float = 0
var buff_de_metralhadora_municao: int = 0
var buff_de_metralhadora_max : float = 10

func _process(delta: float) -> void:
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
	tiro.global_position = global_position
	tiro.direcao = direcao_visao_var
	get_tree().root.add_child(tiro)
	

func buff_de_tiro_metralhadora(delta):
	var tiro = TIRO_PLAYER_BASE.instantiate()
	tiro.global_position = global_position
	tiro.direcao = direcao_visao_var
	get_tree().root.add_child(tiro)
	
	buff_de_metralhadora_municao -= 1
	
func gerenciar_buffs(delta):
	if buff_de_metralhadora_municao > 0:
		tempo_de_tiro = 0.1
	else:
		tempo_de_tiro = tempo_de_tiro_padrao

func movimento(delta : float):
	var movimento_horizontal = Vector2.ZERO
	movimento_horizontal.x = Input.get_action_strength("tecla_direita") - Input.get_action_strength("tecla_esquerda");
		
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if (Input.get_action_strength("tecla_cima") or Input.get_action_strength("pular")) and is_on_floor():
		velocity.y = velocidade_do_pulo
		
	movimento_horizontal = movimento_horizontal.normalized()
	position += movimento_horizontal * velocidade * delta
		
	move_and_slide()

func direcao_visao():
	if Input.is_action_just_pressed("tecla_direita"):
		direcao_visao_var = Vector2.RIGHT
		animated_sprite_2d.scale.x = 1
	elif Input.is_action_just_pressed("tecla_esquerda"):
		direcao_visao_var = Vector2.LEFT
		animated_sprite_2d.scale.x = -1
	elif Input.is_action_just_pressed("tecla_cima"):
		direcao_visao_var = Vector2.UP
	elif Input.is_action_just_pressed("tecla_baixo"):
		direcao_visao_var = Vector2.DOWN
