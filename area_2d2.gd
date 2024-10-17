extends Area2D

var entered = false
var scene_changed = false

func _on_body_entered(body: PhysicsBody2D) -> void:
	entered = true

func _on_body_exited(body: Node2D) -> void:
	entered = false
	scene_changed = false

func _process(delta):
	if entered and not scene_changed:
		scene_changed = true
		get_tree().change_scene_to_file("res://world.tscn")
