extends Node

# Variable para almacenar la próxima escena
var next_scene = "res://Scenes/GraciasPorJugar.tscn"

func _ready():
	$/root/CanvasLayer/ColorRect.modulate = Color(0, 0, 0, 1)
	$/root/CanvasLayer/AnimationPlayer.play("fade_in")
	
	
func _process(delta):
	# Detectar si la tecla "E" está siendo presionada
	if Input.is_action_just_pressed("change_scene"):  # Asumiendo que "E" está asignada a "ui_accept"
		start_scene_transition()

func start_scene_transition():
	# Iniciar el fade out
	$/root/CanvasLayer/AnimationPlayer.play("fade_out")

func _on_animation_finished(animation_name):
	if animation_name == "fade_out":
		# Cambiar a la siguiente escena al finalizar el fade out
		get_tree().change_scene(next_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		# Cambiar a la siguiente escena al finalizar el fade out
		get_tree().change_scene_to_file(next_scene)
