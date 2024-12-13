extends Area2D

@onready var text_label = $"/root/Mundo/CanvasLayer/Texto Lore"
@onready var image_rect = $"/root/Mundo/CanvasLayer/Pergamino"


var show_delay = 0.1 # Tiempo en segundos para mostrar los elementos
var hide_delay = 0.2 # Tiempo en segundos para ocultar los elementos

func _on_body_entered(body: Node2D) -> void:
	print("entro")
	print(get_tree().current_scene, "es la escena")
	if body.name == "Player1":
		# Usar el nombre del nodo raíz de la escena actual
		text_label.visible = true
		image_rect.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player1":
		await get_tree().create_timer(hide_delay).timeout
		# Usar el nombre del nodo raíz de la escena actual
		text_label.visible = false
		image_rect.visible = false
