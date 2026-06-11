extends Control
class_name Botao_Padrao

@export var onda_intensidade : float;
@export var onda_duracao : float;


func comecar_onda(objeto : Object, propriedade : String, final_var : Variant, duracao : float):
		var onda = create_tween()
		onda.tween_property(objeto, propriedade, final_var, duracao)
		
func botao_hovered(button : Button):
	button.pivot_offset = button.size / 2;
	if button.is_hovered():
		comecar_onda(button, "scale", Vector2.ONE * onda_intensidade, onda_duracao)
	else:
		comecar_onda(button, "scale", Vector2.ONE, onda_duracao)
