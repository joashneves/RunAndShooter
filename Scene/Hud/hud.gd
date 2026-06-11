extends Control

#Player 1
@onready var hud_main_player_1: NinePatchRect = $HudMainPlayer1
@onready var bombas_player_1: Label = $HudMainPlayer1/BombasPlayer1
@onready var vida_player_1: Label = $HudMainPlayer1/VidaPlayer1

@onready var player_1 : Player = get_tree().get_first_node_in_group("players")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vida_player_1.text = str(player_1.vida)
	bombas_player_1.text = str(player_1.bombas)
