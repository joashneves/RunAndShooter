extends Botao_Padrao

@onready var tentarnovamente: Button = $Tentarnovamente
@onready var sair: Button = $Sair
@onready var menu: Button = $Menu

func _process(delta: float) -> void:
	botao_hovered(tentarnovamente)
	botao_hovered(menu)
	botao_hovered(sair)
	

func _on_sair_button_down() -> void:
	get_tree().quit()


func _on_menu_button_down() -> void:
	GameManager.VaiParaMenu()


func _on_tentarnovamente_button_down() -> void:
	GameManager.VaiParaLevel1()
