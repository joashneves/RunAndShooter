extends Node

const _817578__SILVERDUBLOONS__SLIDECARD_03 = preload("uid://dyt3dau6hfdrj")

const _843344__BAPTTX__CARD_SLIDE = preload("uid://b4mpxe65w23j5")
var sons_cartas_tiro : Array[AudioStream] = [_817578__SILVERDUBLOONS__SLIDECARD_03, _843344__BAPTTX__CARD_SLIDE]

const _404747__OWLSTORM__RETRO_VIDEO_GAME_SFX_OUCH = preload("uid://bgbt7kwlbkcu")

const _729216__TECHSPIREDMINDS__UPGRADESELECT_UI = preload("uid://idtm7eiuttf6")
const _734842__MUNA_ALANEME__UPGRADE_SOUND_0001 = preload("uid://bsmkkiyuv15ve")
var sons_de_upgrade : Array[AudioStream] = [_729216__TECHSPIREDMINDS__UPGRADESELECT_UI, _734842__MUNA_ALANEME__UPGRADE_SOUND_0001]

func tocar_som_de_carta():
	if sons_cartas_tiro.size() == 0: return
	var player = AudioStreamPlayer.new() # Cria audio player
	add_child(player) #adiciona na scnea atual
	player.pitch_scale = randf_range(0.9,1.2)
	player.stream = sons_cartas_tiro.pick_random() # escolhe um som aleatorio
	player.play() # toca o som
	player.finished.connect(func(): player.queue_free()) # destroi o player no final
	
func tocar_som_de_upgrade():
	if sons_de_upgrade.size() == 0: return
	var player = AudioStreamPlayer.new() # Cria audio player
	add_child(player) #adiciona na scnea atual
	player.pitch_scale = randf_range(0.9,1.2)
	player.stream = sons_de_upgrade.pick_random() # escolhe um som aleatorio
	player.play() # toca o som
	player.finished.connect(func(): player.queue_free()) # destroi o player no final
	
	
func tocar_som_hit():
	var player = AudioStreamPlayer.new() # Cria audio player
	add_child(player) #adiciona na scnea atual
	player.pitch_scale = randf_range(0.9,1.2)
	player.stream = _404747__OWLSTORM__RETRO_VIDEO_GAME_SFX_OUCH # escolhe um som aleatorio
	player.play() # toca o som
	player.finished.connect(func(): player.queue_free()) # destroi o player no final
