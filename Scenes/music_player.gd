extends AudioStreamPlayer


func _ready():
	# Asegúrate de que la música no se reinicie si ya está sonando
	if not self.is_playing():
		self.play()
