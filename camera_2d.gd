extends Camera2D

@onready var player_1  # Referencia al jugador 1
@onready var player_2  # Referencia al jugador 2

var max_distance : float = 200.0  # Distancia máxima entre los jugadores para determinar el zoom de la cámara
var max_zoom : float = 1.5  # Zoom máximo
var screen_size : Vector2  # Tamaño de la pantalla (o área visible)

# Limite en la posición de los jugadores cuando la cámara alcanza el zoom máximo
var limit_position : bool = false  # Determina si se deben limitar las posiciones de los jugadores
var player_1_locked : bool = false  # Indica si Player 1 está detenido
var player_2_locked : bool = false  # Indica si Player 2 está detenido

func _ready() -> void:
	# Asegurarse de que los jugadores están correctamente asignados
	player_1 = $"../Player1"
	player_2 = $"../player2"
	# Obtén el tamaño de la pantalla (o área visible de la cámara)
	screen_size = get_viewport().get_visible_rect().size

	# Inicialmente, la cámara sigue a la media entre los jugadores
	position = (player_1.position + player_2.position) / 2.0
	
func _process(_delta: float) -> void:
	# Calcula la posición media entre Player 1 y Player 2
	var midpoint : Vector2 = (player_1.position + player_2.position) / 2.0
	
	# Aplica un desplazamiento si se necesita (puedes ajustar esto para tener un "offset" en la cámara)
	position = midpoint  # Sin offset por ahora
	
	# Opcional: Ajustar el zoom de la cámara basado en la distancia entre los jugadores
	var distance : float = player_1.position.distance_to(player_2.position)
	zoom = Vector2(max(1.0, distance / max_distance), max(1.0, distance / max_distance))
	
	# Limitar el zoom máximo
	if zoom.x > max_zoom:
		zoom = Vector2(max_zoom, max_zoom)
		limit_position = true  # Activamos el límite de posición cuando el zoom máximo se alcanza
	else:
		limit_position = false  # Desactivamos el límite si el zoom no está al máximo
	
	# Limitar la posición de los jugadores si el zoom está al máximo
	if limit_position:
		limit_player_positions()

# Función para limitar la posición de los jugadores cuando el zoom máximo se alcanza
func limit_player_positions() -> void:
	# Calcula el borde mínimo y máximo que los jugadores pueden alcanzar
	var max_player_distance = screen_size.x/2  # Consideramos que el jugador no puede estar fuera de la mitad de la pantalla

	# Multiplicamos por el zoom para ajustar el límite según el zoom de la cámara
	max_player_distance /= zoom.x  # Ajustamos por el zoom de la cámara

	# Limitar las posiciones de los jugadores
	if player_1.position.x < -max_player_distance:
		player_1.position.x = -max_player_distance
		player_1_locked = true  # Detenemos el movimiento de Player1
	elif player_1.position.x > max_player_distance:
		player_1.position.x = max_player_distance
		player_1_locked = true  # Detenemos el movimiento de Player1

	if player_1.position.y < -max_player_distance:
		player_1.position.y = -max_player_distance
		player_1_locked = true  # Detenemos el movimiento de Player1
	elif player_1.position.y > max_player_distance:
		player_1.position.y = max_player_distance
		player_1_locked = true  # Detenemos el movimiento de Player1
	
	if player_2.position.x < -max_player_distance:
		player_2.position.x = -max_player_distance
		player_2_locked = true  # Detenemos el movimiento de Player2
	elif player_2.position.x > max_player_distance:
		player_2.position.x = max_player_distance
		player_2_locked = true  # Detenemos el movimiento de Player2

	if player_2.position.y < -max_player_distance:
		player_2.position.y = -max_player_distance
		player_2_locked = true  # Detenemos el movimiento de Player2
	elif player_2.position.y > max_player_distance:
		player_2.position.y = max_player_distance
		player_2_locked = true  # Detenemos el movimiento de Player2
func stop_player_movement() -> void:
	# Bloqueamos el movimiento de los jugadores si están "congelados"
	if player_1_locked:
		player_1.velocity = Vector2(0, 0)  # Suponiendo que uses una variable de velocidad en los jugadores
		if player_2_locked:
			player_2.velocity = Vector2(0, 0)  # Lo mismo para Player2
