extends Area2D

@onready var text_label = $"/root/Laberinto/Interaccion potenciometro2"
var player_inside = false

func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	
	
func _on_body_entered(body: Node) -> void:
	if body.name == "player2":
		text_label.visible = true
		player_inside = true

func _on_body_exited(body: Node) -> void:
	if body.name == "player2":
		text_label.visible = false
		player_inside = false

func _process(delta):
	if player_inside and Input.is_action_just_pressed("change_scene"):
		Global.player_positions["Player1"] = $"/root/Laberinto/Player1".global_position
		Global.player_positions["player2"] = $"/root/Laberinto/player2".global_position
		get_tree().change_scene_to_file("res://Scenes/Potenciometro2.tscn")
