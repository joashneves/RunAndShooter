extends GPUParticles2D

func _ready() -> void:
	emitting = true # Garante que ela comece a soltar as partículas assim que nascer
	
	# Cria um timer que dura exatamente o tempo de vida da partícula e a deleta
	await get_tree().create_timer(lifetime).timeout
	queue_free()
