extends Area2D

@onready var text_label = $"/root/Mundo/CanvasLayer/Texto Cartel"
@onready var image_rect = $"/root/Mundo/CanvasLayer/CartelAcertijo"


func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if body.name == "Player1":
		text_label.visible = true
		image_rect.visible = true


func _on_body_exited(body: Node):
	if body.name == "Player1":
		text_label.visible = false
		image_rect.visible = false
