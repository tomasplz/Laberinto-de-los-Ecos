extends Area2D

@onready var text_label = $"/root/World/CanvasLayer/Texto Lore"
@onready var image_rect = $"/root/World/CanvasLayer/Pergamino"

var show_delay = 0.1 #mpo en segundos para mostrar los elementos
var hide_delay = 0.2 # Tiempo en segundos para ocultar los elementos

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		text_label.visible = true
		image_rect.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		await get_tree().create_timer(hide_delay).timeout
		text_label.visible = false
		image_rect.visible = false
