extends Area2D

@onready var text_label = $"/root/Laberinto/Interaccion Final"
var player_inside = false

func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	
	
func _on_body_entered(body: Node) -> void:
	if (body.name == "player2" or body.name =="Player1") and Global.potenciometro1 == true and Global.potenciometro2 == true and Global.potenciometro3 == true:
		print("te pasaste el juego")
		text_label.visible = true
		player_inside = true
	else:
		print("faltan potenciometros pringao")

func _on_body_exited(body: Node) -> void:
	if (body.name == "player2" or body.name =="Player1"):
		text_label.visible = false
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("change_scene") and  Global.potenciometro1 == true and Global.potenciometro2 == true and Global.potenciometro3 == true:
		get_tree().change_scene_to_file("res://Scenes/TransicionFinal.tscn")
