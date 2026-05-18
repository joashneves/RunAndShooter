extends CharacterBody2D

@export var velocidade : float = 100;
@export var velocidade_do_pulo : float = -200;
@export var esta_vivo : bool = false;


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direcao_visao_var : Vector2 = Vector2.ZERO

const TIRO_PLAYER_BASE = preload("uid://d1xy77uo40bm0")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("atira"):
		atirar()

func _physics_process(delta: float) -> void:
	direcao_visao()
	movimento(delta)
	
func atirar():
	var tiro = TIRO_PLAYER_BASE.instantiate()
	tiro.global_position = global_position
	tiro.direcao = direcao_visao_var
	
	get_tree().root.add_child(tiro)

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
	elif Input.is_action_just_pressed("tecla_esquerda"):
		direcao_visao_var = Vector2.LEFT
	elif Input.is_action_just_pressed("tecla_cima"):
		direcao_visao_var = Vector2.UP
	elif Input.is_action_just_pressed("tecla_baixo"):
		direcao_visao_var = Vector2.DOWN
