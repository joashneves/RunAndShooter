extends Botao_Padrao

@onready var iniciar: Button = $Iniciar
@onready var opcoes: Button = $Opcoes
@onready var sair: Button = $Sair

const LEVEL = preload("uid://cjdsyaujwgpn2")

func _process(delta: float) -> void:
	botao_hovered(iniciar)
	botao_hovered(opcoes)
	botao_hovered(sair)


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL)


func _on_sair_button_down() -> void:
	get_tree().quit()
