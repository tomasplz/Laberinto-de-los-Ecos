extends Camera2D

@onready var player_1  
@onready var player_2  

var max_distance : float = 200.0 
var max_zoom : float = 1.5  
var screen_size : Vector2

var limit_position : bool = false  
var player_1_locked : bool = false  
var player_2_locked : bool = false  

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
		limit_player_positions()

func limit_player_positions() -> void:
	var max_player_distance = screen_size.x/2  
	max_player_distance /= zoom.x  
	if player_1.position.x < -max_player_distance:
		player_1.position.x = -max_player_distance
		player_1_locked = true 
	elif player_1.position.x > max_player_distance:
		player_1.position.x = max_player_distance
		player_1_locked = true  

	if player_1.position.y < -max_player_distance:
		player_1.position.y = -max_player_distance
		player_1_locked = true  
	elif player_1.position.y > max_player_distance:
		player_1.position.y = max_player_distance
		player_1_locked = true  
	
	if player_2.position.x < -max_player_distance:
		player_2.position.x = -max_player_distance
		player_2_locked = true 
	elif player_2.position.x > max_player_distance:
		player_2.position.x = max_player_distance
		player_2_locked = true  

	if player_2.position.y < -max_player_distance:
		player_2.position.y = -max_player_distance
		player_2_locked = true  
	elif player_2.position.y > max_player_distance:
		player_2.position.y = max_player_distance
		player_2_locked = true  
func stop_player_movement() -> void:
	if player_1_locked:
		player_1.velocity = Vector2(0, 0)  
		if player_2_locked:
			player_2.velocity = Vector2(0, 0)  
