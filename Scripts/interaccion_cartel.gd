extends Area2D

@onready var text_label = $"/root/World/CanvasLayer/Texto Cartel"
@onready var image_rect = $"/root/World/CanvasLayer/CartelAcertijo"

@onready var text_label_laberinto = $"/root/Laberinto/CanvasLayer/Texto Cartel"
@onready var image_rect_laberinto= $"/root/Laberinto/CanvasLayer/CartelAcertijo"

func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if body.name == "Player1":
		if get_tree().current_scene.name == "Laberinto":
			text_label_laberinto.visible = true
			image_rect_laberinto.visible = true
		elif get_tree().current_scene.name == "Mapa puzzle matriz" or get_tree().current_scene.name == "Mapa puzzle matriz post keypad":
			text_label.visible = true
			image_rect.visible = true


func _on_body_exited(body: Node):
	if body.name == "Player1":
		if get_tree().current_scene.name == "Laberinto":
			text_label_laberinto.visible = false
			image_rect_laberinto.visible = false
		elif get_tree().current_scene.name == "Mapa puzzle matriz" or get_tree().current_scene.name == "Mapa puzzle matriz post keypad":
			text_label.visible = false
			image_rect.visible = false
