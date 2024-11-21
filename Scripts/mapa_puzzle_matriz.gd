extends Node2D

var saved_state = {}

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready() -> void:
	if saved_state.size() > 0:
		_restore_state(saved_state)
	pass

# Llamado cada cuadro. 'delta' es el tiempo transcurrido desde el cuadro anterior.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_scene"):
		saved_state = _save_state()
		

# Guarda el estado actual de la escena
func _save_state() -> Dictionary:
	var state = {}
	state["player_position"] = $Player.position
	return state

# Restaura el estado de la escena
func _restore_state(state: Dictionary) -> void:
	$Player.position = state["player_position"]
   
	
