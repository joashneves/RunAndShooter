extends Inimigo_base

const EXPLOSAO = preload("uid://b2ogss3ffjpyt")

func _ready() -> void:
	super._ready()
	# Sobrescreve as configurações para comportamento de bomba suicida
	recua_do_player = false
	ataque_a_distancia = false
	persegue_player = true
	vida = 1 

# Quando ele encosta no player e vai atacar, ele explode
func atacar_player():
	explodir()

# Sobrescreve a função de checar vida do script pai
func verifica_vida():
	if vida <= 0:
		explodir()
		AudioManager.tocar_som_hit()
		
func _on_area_de_hit_body_entered(body: Node2D) -> void:
	pass
	
# Função própria para gerenciar a explosão com segurança
func explodir():
	if EXPLOSAO:
		var explosao = EXPLOSAO.instantiate()
		explosao.global_position = global_position
		get_tree().root.add_child(explosao)
	
	# Deleta o inimigo DEPOIS de já ter criado a explosão na raiz
	queue_free()
