extends Area2D

@onready var text_label = $"/root/World/CanvasLayer/Texto Lore"
@onready var image_rect = $"/root/World/CanvasLayer/Pergamino"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#text_label.text = "¡Has encontrado un objeto!"
		text_label.visible = true
		image_rect.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		text_label.visible = false
		image_rect.visible = false
