extends CharacterBody2D
class_name BossMao

@export var vida_maxima : int = 5
@export var tempo_recarga_ataque : float = 1.8
@export var tempo_regeneracao : float = 4.0
@export var projetil : PackedScene = preload("res://Scene/Inimigos/Inimigo_base/Tiro_inimigo.tscn")

var vida : int:
	set(value):
		var old_value = vida
		vida = value
		if old_value > 0 and value < old_value:
			piscar_vermelho()
		verifica_vida()
var tempo_recarga_atual : float = 0.0
var posicao_inicial : Vector2
var esta_morta : bool = false

@onready var player : Player = get_tree().get_first_node_in_group("players")
@onready var camera : Camera2D = get_tree().get_first_node_in_group("camera")

func _ready() -> void:
	vida = vida_maxima
	add_to_group("inimigos")
	posicao_inicial = position

func _process(delta: float) -> void:
	if esta_morta:
		return
	
	# Só entra em ação se a batalha tiver começado (cabeça pai travou a câmera)
	var pai = get_parent()
	if pai and "travou_camera" in pai and not pai.travou_camera:
		return

	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("players") as Player

	# Bobbing / Floating animation relative to the head
	position.y = posicao_inicial.y + sin(Time.get_ticks_msec() * 0.004) * 8.0
	
	# Accumulate reload timer
	tempo_recarga_atual += delta
	if tempo_recarga_atual >= tempo_recarga_ataque:
		atacar_player()
		tempo_recarga_atual = 0.0
		
	# Flip sprite visually depending on player position relative to us
	if player and is_instance_valid(player):
		var dir = (player.global_position - global_position).normalized()
		var sprite = get_node_or_null("AnimatedSprite2D")


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
	if esta_morta:
		return
	esta_morta = true
	AudioManager.tocar_som_hit()
	
	# Visual feedback & deactivate
	visible = false
	remove_from_group("inimigos")
	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)
	
	# Wait for regeneration time
	await get_tree().create_timer(tempo_regeneracao).timeout
	regenerar()

func regenerar() -> void:
	vida = vida_maxima
	esta_morta = false
	visible = true
	add_to_group("inimigos")
	var col = get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", false)
