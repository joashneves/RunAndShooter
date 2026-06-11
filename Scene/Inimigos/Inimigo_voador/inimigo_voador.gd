extends Inimigo_base


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
	tiro.direcao = (player.global_position - global_position).normalized()
	get_tree().root.add_child(tiro)
	await get_tree().create_timer(0.5).timeout
	status_atual = status[1]

func movimento_inimigo(delta):
	velocity.x = direcao.x * velocidade
	move_and_slide()
	
	if is_on_wall():
		flip()
	
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


func _on_area_de_player_body_exited(body: Node2D) -> void:
	if body == player:
		player == null
