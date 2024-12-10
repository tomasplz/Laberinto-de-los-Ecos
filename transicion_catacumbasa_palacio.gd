extends Node  # Asegúrate de que este script esté en el nodo principal adecuado

# Definimos el texto completo
var full_text = "Después de superar los oscuros laberintos de las catacumbas, Aiden y Elara se dirigen ahora al majestuoso palacio que se alza frente a ellos, buscando respuestas y un nuevo desafío."
var current_text = ""
var char_index = 0
var typing_speed = 0.1  # Velocidad de la escritura, ajustable

func _ready():
	# Asegurarnos de que el texto esté vacío al principio
	$CanvasLayer/Label.text = ""
	
	# Crear el temporizador
	var timer = Timer.new()
	add_child(timer)  # Añadimos el temporizador como hijo del nodo
	timer.wait_time = typing_speed  # Velocidad de la escritura
	timer.one_shot = false  # Queremos que el temporizador se repita
	
	# Conectar la señal de timeout a la función _on_Timer_timeout
	timer.connect("timeout", self, "_on_Timer_timeout")  # Aquí pasamos la función correctamente como callable
	
	# Iniciar el temporizador
	timer.start()

# Esta función se llama cada vez que el temporizador se dispara
func _on_Timer_timeout():
	if char_index < full_text.length():
		current_text += full_text[char_index]  # Añadimos una letra al texto
		$CanvasLayer/Label.text = current_text  # Actualizamos el texto en el Label
		char_index += 1  # Avanzamos al siguiente carácter
	else:
		$CanvasLayer/Label.text = full_text  # Asegurarnos de que el texto final se muestre completo
