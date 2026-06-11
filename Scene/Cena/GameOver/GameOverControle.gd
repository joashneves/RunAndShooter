extends Botao_Padrao

@onready var tentarnovamente: Button = $Tentarnovamente
@onready var sair: Button = $Sair
@onready var menu: Button = $Menu

func _process(delta: float) -> void:
	botao_hovered(tentarnovamente)
	botao_hovered(menu)
	botao_hovered(sair)
	
