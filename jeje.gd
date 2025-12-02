extends StaticBody3D

@export var distance: float = 0.5     # Cuánto avanza el pistón
@export var speed: float = 1.0        # Velocidad de movimiento
var t := 0.0
var start_pos: Vector3

func _ready():
	start_pos = global_position

func _physics_process(delta):
	# Oscilación suave hacia adelante y atrás
	t += speed * delta
	var offset = sin(t) * distance

	# Solo se mueve sobre un eje (ej: Z)
	global_position = start_pos - Vector3(offset, 0, 0)
