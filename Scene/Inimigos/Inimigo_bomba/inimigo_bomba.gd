extends Inimigo_base

const EXPLOSAO = preload("uid://b2ogss3ffjpyt")

func _ready() -> void:
	super._ready()
	# Sobrescreve as configurações para comportamento de bomba suicida
	recua_do_player = false
	ataque_a_distancia = false
	persegue_player = true
	vida = 1 # O inimigo bomba morre com 1 tiro

func atacar_player():
	queue_free()

func _exit_tree() -> void:
	if is_inside_tree():
		var explosao = EXPLOSAO.instantiate()
		explosao.global_position = global_position
		get_tree().root.add_child(explosao)
