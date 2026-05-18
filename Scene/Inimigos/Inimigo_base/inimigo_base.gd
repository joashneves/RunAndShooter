extends CharacterBody2D
class_name Inimigo_base

@export var velocidade : float = 100;

var inimigo_na_tela : bool = false
var direcao : Vector2 = Vector2.LEFT
var vida : int = 1;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta: float) -> void:
	if not inimigo_na_tela: return
	verifica_vida()

func _physics_process(delta: float) -> void:
	if not inimigo_na_tela: return
	movimento_inimigo(delta)

func movimento_inimigo(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	position += direcao * velocidade * delta
	
	move_and_slide()
	
func verifica_vida():
	if vida <= 0:
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	inimigo_na_tela = true
