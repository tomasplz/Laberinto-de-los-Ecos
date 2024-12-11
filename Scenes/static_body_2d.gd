extends Node

@onready var animation_player =$AnimationPlayer
@onready var camera1 = $"../Camera2D" # Referencia a la primera cámara
@onready var camera2 =  $"../Camera2D2" # Referencia a la segunda cámara
@onready var bloqueo=$"../StaticBody2D2"
func _process(_delta):
	if(camera2.enabled==true):# Detectar si se presionó la acción 'play_animation'
		if Input.is_action_just_pressed("ui_animacioncopa"):
			animation_player.play("copa")
			if is_instance_valid(bloqueo):
				bloqueo.queue_free()
		if Input.is_action_just_pressed("mitad"):
			animation_player.play("copamitad")
			
		if Input.is_action_just_pressed("vacia"):
			animation_player.play("copacasivacia")
			
		if(Input.is_action_just_pressed("ui_cambio de camara")):
			camera1.enabled=true  # Desactiva la primera cámara
			camera2.enabled=false   # Activa la segunda cámara
		
