extends Camera2D

@onready var player_1  
@onready var player_2  

var max_distance : float = 200.0 
var max_zoom : float = 1.5  
var screen_size : Vector2

var limit_position : bool = false  

# Posición específica para teletransportar a los jugadores si se salen del límite
var reset_position : Vector2 = Vector2(70, -200)  

func _ready() -> void:	
	player_1 = $"../Player1"
	player_2 = $"../player2"
	screen_size = get_viewport().get_visible_rect().size
	position = (player_1.position + player_2.position) / 2.0
	
func _process(_delta: float) -> void:
	var midpoint : Vector2 = (player_1.position + player_2.position) / 2.0
	position = midpoint  
	var distance : float = player_1.position.distance_to(player_2.position)
	zoom = Vector2(max(1.0, distance / max_distance), max(1.0, distance / max_distance))
	if zoom.x > max_zoom:
		zoom = Vector2(max_zoom, max_zoom)
		limit_position = true 
	else:
		limit_position = false  
	if limit_position:
		teleport_out_of_bounds_players()

# Método para teletransportar jugadores que están fuera de los límites
func teleport_out_of_bounds_players() -> void:
	var max_player_distance = screen_size.x / 2  
	max_player_distance /= zoom.x  

	# Verificar y teletransportar Player 1
	if player_1.position.x < -max_player_distance or player_1.position.x > max_player_distance \
	or player_1.position.y < -max_player_distance or player_1.position.y > max_player_distance:
		player_1.position = reset_position

	# Verificar y teletransportar Player 2
	if player_2.position.x < -max_player_distance or player_2.position.x > max_player_distance \
	or player_2.position.y < -max_player_distance or player_2.position.y > max_player_distance:
		player_2.position = reset_position
