extends CharacterBody2D
class_name BossCabeca

@export var vida_maxima : int = 30
@export var tempo_recarga_ataque : float = 2.0
@export var projetil : PackedScene = preload("res://Scene/Inimigos/Inimigo_base/Tiro_inimigo.tscn")

var vida : int:
	set(value):
		var old_value = vida
		vida = value
		if old_value > 0 and value < old_value:
			piscar_vermelho()
		verifica_vida()
var tempo_recarga_atual : float = 0.0

@onready var player : Player = get_tree().get_first_node_in_group("players")
@onready var camera : Camera2D = get_tree().get_first_node_in_group("camera")

var screen_notifier : VisibleOnScreenNotifier2D
var travou_camera : bool = false

func _ready() -> void:
	vida = vida_maxima
	add_to_group("inimigos")
	
	# Criar notifier de tela dinamicamente para saber quando o boss entra na tela
	screen_notifier = VisibleOnScreenNotifier2D.new()
	add_child(screen_notifier)
	screen_notifier.screen_entered.connect(_on_screen_entered)

func _process(delta: float) -> void:
	# Garantir que trava a câmera se já estiver na tela (fallback)
	if not travou_camera and screen_notifier and screen_notifier.is_on_screen():
		_on_screen_entered()

	# Só se comporta e ataca se a batalha tiver começado (boss na tela)
	if not travou_camera:
		return

	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("players") as Player

	# Accumulate reload timer
	tempo_recarga_atual += delta
	if tempo_recarga_atual >= tempo_recarga_ataque:
		atacar_player()
		tempo_recarga_atual = 0.0
		
	# Flip sprite visually depending on player position relative to us
	if player and is_instance_valid(player):
		var dir = (player.global_position - global_position).normalized()
		var sprite = get_node_or_null("AnimatedSprite2D")
		

func _on_screen_entered() -> void:
	if travou_camera:
		return
	travou_camera = true
	if camera and "travada" in camera:
		camera.travada = true
		position =  Vector2(position.x - 16, position.y)
		print("Boss entrou na tela! Travando câmera.")

func atacar_player() -> void:
	if not projetil:
		return
	if player and is_instance_valid(player) and player.esta_vivo:
		var tiro = projetil.instantiate()
		tiro.global_position = global_position
		tiro.direcao = (player.global_position - global_position).normalized()
		tiro.rotation = tiro.direcao.angle()
		get_tree().root.add_child(tiro)

func piscar_vermelho() -> void:
	var sprite = get_node_or_null("AnimatedSprite2D")
	if camera:
		camera.screen_shake()
	if sprite:
		sprite.modulate = Color(2.5, 0.4, 0.4, 1.0)
		await get_tree().create_timer(0.15).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func verifica_vida() -> void:
	if vida <= 0:
		morrer()

func morrer() -> void:
	# Libera a câmera
	if camera and "travada" in camera:
		camera.travada = false
		print("Boss derrotado! Câmera liberada.")
		
	GameManager.pontos += 100 # Boss points!
	GameManager.hitStop()
	AudioManager.tocar_som_hit()
	queue_free()
