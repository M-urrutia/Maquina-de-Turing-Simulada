extends CharacterBody3D
# Este script controla un personaje 3D con movimiento libre tipo FPS.

@export var mouse_sensitivity := 0.002
# Sensibilidad del mouse al mover la cámara (más alto = más rápido)

@export var move_speed := 5.0
# Velocidad de movimiento del personaje

var rotation_x := 0.0  # Pitch (rotación vertical: mirar arriba/abajo)
var rotation_y := 89.5 # Yaw (rotación horizontal: mirar izquierda/derecha)

@export var camera = Camera3D
# Referencia a la cámara que rota verticalmente

@export var area = Area3D
# Referencia a un Area3D que también rota verticalmente (probablemente para detección)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Oculta y captura el cursor dentro de la ventana para usar estilo FPS


func _unhandled_input(event):
	# Se ejecuta cuando ocurre una entrada no consumida por otros nodos

	if event is InputEventMouseMotion:
		# Si el mouse se mueve...

		rotation_y -= event.relative.x * mouse_sensitivity
		# Movimiento horizontal del mouse -> rota el cuerpo (yaw)

		rotation_x -= event.relative.y * mouse_sensitivity
		# Movimiento vertical del mouse -> rota la cámara (pitch)

		rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
		# Limita la rotación vertical para evitar que gire completamente

		rotation.y = rotation_y
		# Aplica la rotación horizontal al personaje completo

		camera.rotation.x = rotation_x
		# Aplica la rotación vertical solo a la cámara

		area.rotation.x = rotation_x
		# También rota el Area3D verticalmente (útil para raycasts, detección, etc)


func _physics_process(delta):
	# Se ejecuta cada frame físico (movimiento con física)

	var direction = Vector3.ZERO
	# Vector que acumulará la dirección de movimiento

	var forward = -transform.basis.z
	# Vector hacia adelante del personaje

	var right = transform.basis.x
	# Vector hacia la derecha

	var up = transform.basis.y
	# Vector hacia arriba


	# --- CONTROLES DE MOVIMIENTO ---
	if Input.is_action_pressed("move_forward"):
		direction += forward
	if Input.is_action_pressed("move_back"):
		direction -= forward
	if Input.is_action_pressed("move_left"):
		direction -= right
	if Input.is_action_pressed("move_right"):
		direction += right
	if Input.is_action_pressed("ui_up"):
		direction += up
	if Input.is_action_pressed("move_down"):
		direction -= up

	# Tecla para cerrar el juego
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()


	direction = direction.normalized()
	# Normaliza para evitar que mover en diagonal sea más rápido

	velocity = direction * move_speed
	# Calcula la velocidad final

	move_and_slide()
	# Aplica el movimiento con colisiones
