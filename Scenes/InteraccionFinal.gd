extends Area2D

@onready var text_label = $"/root/Laberinto/Interaccion Final"
var player_inside = false

func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	
	
func _on_body_entered(body: Node) -> void:
	if (body.name == "player2" or body.name =="Player1") and Global.num_potenciometros==3:
		text_label.visible = true
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if (body.name == "player2" or body.name =="Player1") and Global.num_potenciometros==3:
		text_label.visible = false
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("change_scene") and Global.num_potenciometros==3:
		get_tree().change_scene_to_file("res://Scenes/Potenciometro1.tscn")
