extends Node

const GAME_OVER = preload("uid://c16op0yg1bwgn")
const MAIN_MENU = preload("uid://bx3jhbb7onn8d")
const LEVEL = preload("uid://cjdsyaujwgpn2")

func VaiParaGameOver():
	get_tree().change_scene_to_packed(GAME_OVER);

func VaiParaMenu():
	get_tree().change_scene_to_packed(MAIN_MENU);

func VaiParaLevel1():
	get_tree().change_scene_to_packed(LEVEL);
