extends CharacterBody2D

var speed : = 120
var direccion : = 0.0
var direccion2: = 0.0
@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D
func _physics_process(_delta):
	direccion = Input.get_axis("ui_left","ui_right") 
	direccion2= Input.get_axis("ui_up","ui_down")
	velocity.x = direccion * speed
	velocity.y = direccion2 * speed
	var animacion_a_reproducir = ""
	if direccion != 0:
		animacion_a_reproducir="walk"
	else:
		if direccion2<0:
			animacion_a_reproducir="idle up"
		elif direccion2>0:
			animacion_a_reproducir="idle"
		else:
			animacion_a_reproducir="idleh"
		
	if direccion2 < 0:
		animacion_a_reproducir = "walk up"
	elif direccion2 > 0:
		animacion_a_reproducir = "walk down"
	if animacion_a_reproducir != " ":
		anim.play(animacion_a_reproducir)
	sprite.flip_h = direccion < 0 if direccion!=0 else sprite.flip_h 
	move_and_slide()
