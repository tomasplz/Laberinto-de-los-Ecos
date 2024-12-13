extends Node2D

var codigo = "A23*0#";
@onready var arduino_control = $Control
var codigo_actual = ""
@onready var Digito0 = $'0DIgito'
@onready var Digito1 = $'1Digito'
@onready var Digito2 = $'2Digito'
@onready var Digito3 = $'3Digito'
@onready var Digito4 = $'4Digito'
@onready var Digito5 = $'5Digito'
@onready var Digito6 = $'6Digito'

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	# Conectar la señal desde el script
	arduino_control.connect("KeypadInput", _on_keypad_input)


func _on_keypad_input(input: String):
	# numero maximo de caracteres en el codigo es 6
	# Procesar el input del keypad aquí
	print("Input recibido: ", input)
	# Aquí puedes agregar la lógica para validar el código
	
	codigo_actual += input
	print ("Codigo actual: ", codigo_actual)

	if codigo_actual.length() == 0:
		Digito0.visible = true
	elif codigo_actual.length() == 1:
		Digito1.visible = true
	elif codigo_actual.length() == 2:
		Digito2.visible = true
		Digito1.visible = false
	elif codigo_actual.length() == 3:
		Digito3.visible = true
		Digito2.visible = false
	elif codigo_actual.length() == 4:
		Digito4.visible = true
		Digito3.visible = false
	elif codigo_actual.length() == 5:
		Digito5.visible = true
		Digito4.visible = false
	elif codigo_actual.length() == 6:
		Digito6.visible = true
		Digito5.visible = false
		print("timer")
		await get_tree().create_timer(0.2).timeout
		if codigo_actual == codigo:
			print("Codigo correcto")
			Global.player_positions["player1"] = null;
			Global.player_positions["player2"] = null;
			Global.keypad_1 = true;
			if arduino_control:
				# Desconectar señales
				if arduino_control.has_signal("KeypadInput"):
					arduino_control.disconnect("KeypadInput", _on_keypad_input)
				
				# Cerrar puerto
				arduino_control.CloseConnection()
				arduino_control.queue_free()
				
			# Pequeño delay para asegurar que todo se cierre
			# Cambiar escena
			get_tree().change_scene_to_file("res://Scenes/Mapa puzzle matriz post keypad.tscn")
		else:
			print("Codigo incorrecto")
			Digito6.visible = false
			codigo_actual = ""
			

# Llamado cada cuadro. 'delta' es el tiempo transcurrido desde el cuadro anterior.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_scene"):
		if arduino_control:
				# Desconectar señales
				if arduino_control.has_signal("KeypadInput"):
					arduino_control.disconnect("KeypadInput", _on_keypad_input)
				
				# Cerrar puerto
				arduino_control.CloseConnection()
				arduino_control.queue_free()
		get_tree().change_scene_to_file("res://Scenes/Mapa puzzle matriz.tscn")
