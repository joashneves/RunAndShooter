extends Area2D
class_name upgrade_de_3_tiros


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.buff_de_3_tiros_municao = 100
		AudioManager.tocar_som_de_upgrade()
		queue_free()
	
