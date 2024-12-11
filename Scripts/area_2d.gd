extends Area2D

@onready var player = $"../Player1"  # Asegúrate de que el Player1 esté correctamente referenciado
@onready var camera1 = $"../Camera2D" # Referencia a la primera cámara
@onready var camera2 =  $"../Camera2D2" # Referencia a la segunda cámara

func _ready():
	monitoring = false  # Asegura que la propiedad 'monitoring' esté activada

# Método que se llama cuando un cuerpo entra en el área
func _on_body_entered(body: Node):
	if body == player:  # Verifica que sea el jugador
		print("Jugador ha entrado en el área")
		camera1.enabled=false  # Desactiva la primera cámara
		camera2.enabled=true   # Activa la segunda cámara
