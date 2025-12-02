extends RigidBody3D
# Este nodo representa un objeto físico que puede moverse
# solo cuando el jugador (u otro cuerpo) está dentro de una zona de interacción.

@onready var estado = 0
# Estado binario del objeto:
# 0 = posición inicial
# 1 = posición desplazada

@export var distancia_movimiento: float = 0.4  
# Distancia que se moverá el objeto sobre el eje X
# (aunque el comentario decía Z, realmente se mueve en X)

var dentro_area := false
# Indica si este cuerpo está dentro de una zona válida de interacción


func _ready():
	# Se conecta automáticamente a todas las áreas que pertenezcan
	# al grupo "zona_interaccion"
	for area in get_tree().get_nodes_in_group("zona_interaccion"):
		area.body_entered.connect(_on_area_entered)
		area.body_exited.connect(_on_area_exited)


func _input(event):
	# Detecta cuando se presiona la acción "cambiar_estado"
	# Solo permite mover el objeto si está dentro del área permitida
	if event.is_action_pressed("cambiar_estado") and dentro_area:
		mover_en_z()


func mover_en_z():
	# Congela la física para evitar fuerzas y colisiones
	# mientras se reposiciona manualmente el cuerpo
	freeze = true

	if estado == 0:
		# Desplaza el objeto en dirección negativa del eje X
		global_position.x -= distancia_movimiento
		estado = 1
	else:
		# Lo devuelve a su posición original
		global_position.x += distancia_movimiento
		estado = 0

	# Reactiva la simulación física
	freeze = false


# Se ejecuta cuando este cuerpo entra en una zona de interacción
func _on_area_entered(body):
	if body == self:
		dentro_area = true


# Se ejecuta cuando este cuerpo sale de la zona
func _on_area_exited(body):
	if body == self:
		dentro_area = false
