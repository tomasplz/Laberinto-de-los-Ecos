extends CharacterBody2D

# Velocidad de movimiento del personaje
@export var speed := 200.0

func _physics_process(delta):
	# Inicializa la dirección de movimiento como Vector2(0, 0)
	var direction := Vector2.ZERO

	# Usa las teclas de dirección para moverse en 8 direcciones
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normaliza el vector para asegurar velocidad constante en diagonales
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Asigna la velocidad al movimiento y aplica la dirección
	velocity = direction * speed
	# Mueve el personaje con la función move_and_slide
	move_and_slide()
