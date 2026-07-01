extends Control

@onready var animation : AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause") and  !get_tree().paused):
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
	
func resume():
	get_tree().paused = false;
	animation.play_backwards("blur")
	
func pause():
	get_tree().paused = true;
	animation.play("blur")
