extends Node

@onready var animation_player = $AnimationPlayer
@onready var status_label = $"../Control/StatusLabel"
var current_level = 0  # 0: vacía, 1: mitad, 2: llena
var animation_completed = true

func _ready():
	var arduino = $"../Control"
	arduino.WaterLevelChanged.connect(_on_water_level_changed)
	animation_player.animation_finished.connect(_on_animation_finished)
	status_label.text = "Llena la copa con agua"

func _on_animation_finished(_anim_name):
	animation_completed = true
	if current_level >= 1:  # Para nivel mitad y lleno
		animation_player.seek(0.866667, true)
		animation_player.pause()

func change_scene():
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/mundo.tscn")

func _on_water_level_changed(level: float):
	if level >= 550 and current_level != 2:
		if current_level == 1 and animation_completed:
			animation_player.play("copa")
		elif current_level == 0 and animation_completed:
			animation_player.play("copamitad")
			animation_player.animation_finished.connect(
				func(_anim_name): 
					animation_player.play("copa"),
				CONNECT_ONE_SHOT
			)
		status_label.text = "¡Logrado!";
		Global.copa_1 = true;
		var arduino = $"../Control"
		if arduino:
			# Desconectar señales primero
			arduino.WaterLevelChanged.disconnect(_on_water_level_changed)
			arduino.CloseConnection()
		if is_inside_tree():
			var timer = get_tree().create_timer(2.0)
			timer.timeout.connect(change_scene)
		current_level = 2
		
	elif level >= 100 and level < 600 and current_level != 1:
		status_label.text = "¡Ya casi! Un poco más..."
		if current_level == 0 and animation_completed:
			animation_player.play("copamitad")
		elif current_level == 2:
			animation_player.play("copamitad")
		current_level = 1
		animation_completed = false
		
	elif level < 100 and current_level != 0:
		status_label.text = "Le falta más agua"
		animation_player.play("copacasivacia")
		animation_player.seek(0, true)
		animation_player.pause()
		current_level = 0
		animation_completed = true
