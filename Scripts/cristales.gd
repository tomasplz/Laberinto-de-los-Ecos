extends Area2D

@onready var text_label = $"/root/World/CanvasLayer/Texto Lore"
@onready var image_rect = $"/root/World/CanvasLayer/Pergamino"

@onready var text_label_palacio = $"/root/Mundo/CanvasLayer/Texto Lore"
@onready var image_rect_palacio= $"/root/Mundo/CanvasLayer/Pergamino"

@onready var text_label_laberinto = $"/root/Laberinto/CanvasLayer/Texto Lore"
@onready var image_rect_laberinto = $"/root/Laberinto/CanvasLayer/Pergamino"

var show_delay = 0.1 # Tiempo en segundos para mostrar los elementos
var hide_delay = 0.2 # Tiempo en segundos para ocultar los elementos


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player1":
		# Usar el nombre del nodo raíz de la escena actual
		if get_tree().current_scene.name == "Laberinto":
			text_label_laberinto.visible = true
			image_rect_laberinto.visible = true
		elif get_tree().current_scene.name == "Mapa puzzle matriz" or get_tree().current_scene.name == "Mapa puzzle matriz post keypad":
			text_label.visible = true
			image_rect.visible = true
		elif get_tree().current_scene.name == "Mundo":
			text_label_palacio.visible = true
			image_rect_palacio.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player1":
		await get_tree().create_timer(hide_delay).timeout
		# Usar el nombre del nodo raíz de la escena actual
		if get_tree().current_scene.name == "Laberinto":
			text_label_laberinto.visible = false
			image_rect_laberinto.visible = false
		elif get_tree().current_scene.name == "Mapa puzzle matriz" or get_tree().current_scene.name == "Mapa puzzle matriz post keypad" :
			text_label.visible = false
			image_rect.visible = false
