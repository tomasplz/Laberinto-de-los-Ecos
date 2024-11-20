extends Node2D

@export var zoom_in_limit := 3.0
@export var zoom_out_limit := 0.5
@export var zoom_speed := 1.5

var zoom_level = 1.0

func _input(event):
	if event.is_action_pressed("zoom_in", true):
		zoom_level += get_process_delta_time() * zoom_speed
		
	if event.is_action_pressed("zoom_out", true):
		zoom_level -= get_process_delta_time() * zoom_speed
		
	$Camera2D.zoom = Vector2(zoom_level, zoom_level)
	zoom_level = clamp(zoom_level, zoom_out_limit, zoom_in_limit)
