extends CharacterBody2D

var velocidad:int = 300
var fueza_salto = -650
const gravity = 1200
var direction = null

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * velocidad
	
	if not is_on_floor():
		velocity.y += delta * gravity

	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = fueza_salto
	
	
	move_and_slide()
