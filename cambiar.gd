extends RigidBody3D

@export var distancia_movimiento: float = 3.0
@export var area_objetivo: Area3D

var dentro_area := false

func _ready():
	area_objetivo.body_entered.connect(_on_body_entered)
	area_objetivo.body_exited.connect(_on_body_exited)


func _input(event):
	if event.is_action_pressed("cambiar_estado") and dentro_area:
		mover_rigidbody()


func mover_rigidbody():
	var direccion = -transform.basis.z.normalized() # hacia adelante local
	var nueva_posicion = global_position + direccion * distancia_movimiento

	# Método seguro para RigidBody
	freeze = true
	global_position = nueva_posicion
	freeze = false


func _on_body_entered(body):
	if body == self:
		dentro_area = true


func _on_body_exited(body):
	if body == self:
		dentro_area = false
