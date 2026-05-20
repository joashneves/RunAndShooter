extends Inimigo_base


func _physics_process(delta: float) -> void:
	if not inimigo_na_tela: return
	match status_atual:
		"pensando":
			pass
		"movendo":
			movimento_inimigo(delta)
		"atacando":
			pass
			
func atacar_player():
	print("atirando")
	var tiro = projetil.instantiate()
	tiro.global_position = global_position
	tiro.direcao = (player.global_position - global_position).normalized()
	get_tree().root.add_child(tiro)
	await get_tree().create_timer(0.5).timeout
	status_atual = status[1]
			
func movimento_inimigo(delta):
	position += direcao * velocidade * delta
	move_and_slide()
	
# Quando player tocar no hit faça alguma coisa
func _on_area_de_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		velocidade = 0
		get_tree().reload_current_scene()


func _on_area_de_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		status_atual = status[0]
		atacar_player()
		player = body
