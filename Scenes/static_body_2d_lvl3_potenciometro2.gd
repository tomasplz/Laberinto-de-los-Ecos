extends Node2D

@onready var porcentaje0 = $'0 por ciento'
@onready var porcentaje10 = $'10 por ciento'
@onready var porcentaje30 = $'30 por ciento'
@onready var porcentaje45 = $'45 por ciento'
@onready var porcentaje50 = $'50 por ciento'
@onready var porcentaje65 = $'65 por ciento'
@onready var porcentaje80 = $'80 por ciento'
@onready var porcentaje100 = $'100 por ciento'

#@onready var status_label = $StatusLabel  # Ajusta según tu estructura

func _ready():
	var arduino = $'../Control'  # Ajusta según tu estructura
	arduino.PotentiometerChanged.connect(_on_potentiometer_changed)

func change_scene():
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/Laberinto.tscn")

func _on_potentiometer_changed(value: float):
	var current_percentage = value
	print(current_percentage, "es el porcentaje")

	if value < 3:
		porcentaje0.visible = true
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value >= 0 and value <= 10:  # Rango del 0-10%
		porcentaje0.visible = false
		porcentaje10.visible = true
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value > 10 and value <= 30: #rango 10-30%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = true
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value > 30 and value <= 45: #rango 30-45%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = true
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value > 45 and value <= 50: #rango 45-50%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = true
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value > 50 and value <= 65: #rango 50-65%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = true
		porcentaje80.visible = false
		porcentaje100.visible = false
		Global.potenciometro2 = false
	elif value > 65 and value <= 80: #rango 65-80%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = true
		porcentaje100.visible = false
		Global.potenciometro2 = true #Rango 80 TRUE
	elif value > 80 and value <= 100: #rango 65-80%
		porcentaje0.visible = false
		porcentaje10.visible = false
		porcentaje30.visible = false
		porcentaje45.visible = false
		porcentaje50.visible = false
		porcentaje65.visible = false
		porcentaje80.visible = false
		porcentaje100.visible = true
		Global.potenciometro2 = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_scene"):
		var arduino = $"../Control"
		if arduino:
			# Desconectar señales primero
			arduino.PotentiometerChanged.disconnect(_on_potentiometer_changed)
			arduino.CloseConnection()
		get_tree().change_scene_to_file("res://Scenes/Laberinto.tscn")
		#var arduino = $"../Control"
		#if arduino:
			## Desconectar señales primero
			#arduino.PotentiometerChanged.disconnect(_on_potentiometer_changed)
			#arduino.CloseConnection()
		#if is_inside_tree():
			#var timer = get_tree().create_timer(2.0)
			#timer.timeout.connect(change_scene)
