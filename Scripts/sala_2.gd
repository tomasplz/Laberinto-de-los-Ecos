extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Conectamos las señales usando Callable
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body: Node):
	if body.name == "Player":
		print("Sala 2")
