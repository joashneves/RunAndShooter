extends CharacterBody2D
class_name Inimigo_base

@export var velocidade : float = 50;
@export var projetil : PackedScene;

var status : Array = ["pensando", "movendo", "atacando"]
var status_atual : String = status[1]

var velocidade_maxima : float = velocidade

var inimigo_na_tela : bool = false
var direcao : Vector2 = Vector2.LEFT
var vida : int = 1;

@onready var player : Player = get_tree().get_first_node_in_group("players")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	if player:
		if player.position.x < position.x:
			scale.x = -1
			direcao = Vector2.LEFT
		elif player.position.x > position.x:
			scale.x = 1			
			direcao = Vector2.RIGHT

func _process(delta: float) -> void:
	if not inimigo_na_tela: return
	
	verifica_vida()

func _physics_process(delta: float) -> void:
	if not inimigo_na_tela: return
	match status_atual:
		"pensando":
			pass
		"movendo":
			movimento_inimigo(delta)
			check_camera_boundaries()
		"atacando":
			pass
			
func atacar_player():
	print("atirando")
	var tiro = projetil.instantiate()
	tiro.global_position = global_position
	tiro.direcao = direcao
	get_tree().root.add_child(tiro)
	await get_tree().create_timer(0.5).timeout
	status_atual = status[1]

func movimento_inimigo(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direcao.x * velocidade
	move_and_slide()
	
	if is_on_wall():
		flip()

func flip():
	direcao.x *= -1
	scale.x = direcao.x

func check_camera_boundaries():
	var cam = get_viewport().get_camera_2d()
	if cam:
		var largura_da_tela = get_viewport_rect().size.x / cam.zoom.x
		var borda_esquerda = cam.global_position.x - (largura_da_tela / 2)
		var borda_direita = cam.global_position.x + (largura_da_tela / 2)
		
		if global_position.x <= borda_esquerda and direcao.x < 0:
			flip()
		elif global_position.x >= borda_direita and direcao.x > 0:
			flip()
	
func verifica_vida():
	if vida <= 0:
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	inimigo_na_tela = true

# Quando player tocar no hit faça alguma coisa
func _on_area_de_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		velocidade = 0
		body.morte()


func _on_area_de_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		status_atual = status[0]
		atacar_player()
		player = body
