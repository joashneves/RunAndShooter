extends Inimigo_base

const EXPLOSAO = preload("uid://b2ogss3ffjpyt")

func atacar_player():
	queue_free()


func _exit_tree() -> void:
	var explosao = EXPLOSAO.instantiate()
	explosao.global_position = global_position
	get_tree().root.add_child(explosao)
