extends Node  # Cambié el tipo de nodo a Node

# Definimos el texto completo
var full_text = "Después de superar los oscuros laberintos de las catacumbas, Aiden y Elara se dirigen ahora al majestuoso palacio que se alza frente a ellos, buscando respuestas y un nuevo desafío."
var current_text = ""
var typing_speed = 0.1  # Velocidad de la escritura, ajustable

func _ready():
	# Asegurarnos de que el texto esté vacío al principio
	$/root/CanvasLayer/Label.text = ""
	
	# Crear la animación para la escritura
	create_typing_animation()

	# Reproducir la animación
	$/root/CanvasLayer/AnimationPlayer.play("write_text")

# Esta función crea la animación que va a cambiar el texto poco a poco
func create_typing_animation():
	var anim = $/root/CanvasLayer/AnimationPlayer.get_animation("write_text")
	if anim == null:
		anim = Animation.new()
		$/root/CanvasLayer/AnimationPlayer.add_animation("write_text", anim)
	
	# Añadir una nueva pista para el texto
	anim.add_track(Animation.TYPE_VALUE)
	
	# Configuramos la animación para ir añadiendo texto
	for i in range(full_text.length()):
		anim.track_insert_key(0, float(i) * typing_speed, full_text.substr(0, i + 1))  # Añade la clave de texto
	
	# Ajustamos la duración de la animación
	anim.length = float(full_text.length()) * typing_speed
