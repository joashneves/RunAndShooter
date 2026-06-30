extends Area2D
class_name upgrade_metralhadora


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.buff_de_metralhadora_municao = 100
		AudioManager.tocar_som_de_upgrade()
		queue_free()
	
