extends Node3D
# Este nodo representa un engranaje que gira sincronizado
# con el movimiento de una cinta (Path3D con followers).

# Referencia a la cinta (Path3D) que controla el movimiento lineal
@onready var cinta = get_parent().get_node("Path3D")

# Radio del engranaje en unidades reales 3D
# Mientras más grande el radio, más lento girará para la misma velocidad lineal
@export var radio_engranaje: float = 1


func _process(delta):
	# Solo gira cuando la cinta está en movimiento
	if cinta.moviendo:

		# Velocidad lineal de la cinta (unidades / segundo)
		var velocidad_lineal = cinta.get_velocidad_lineal()

		# Conversión física:
		# v = ω * r  →  ω = v / r
		# Esto entrega la velocidad angular en radianes/segundo
		var velocidad_angular = velocidad_lineal / radio_engranaje

		# Rotación del engranaje:
		# delta lo hace dependiente del tiempo real del frame
		# cinta.direccion determina el sentido (+ o -)
		rotate_x(velocidad_angular * delta * cinta.direccion)
