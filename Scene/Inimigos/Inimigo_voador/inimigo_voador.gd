extends Inimigo_base

func _ready() -> void:
	super._ready()
	# Sobrescreve as configurações para comportamento voador
	is_flying = true
	mira_no_player = true
