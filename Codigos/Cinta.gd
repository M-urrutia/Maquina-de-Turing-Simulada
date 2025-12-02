extends Path3D
# Este script controla el movimiento de varios PathFollow3D
# que están distribuidos a lo largo del Path3D padre.

# Señal que se emite cuando el movimiento termina
signal movimiento_terminado

# Porcentaje del recorrido del path que se moverá cada vez (0.1 = 10%)
@export var porcentaje_movimiento: float = 0.1  

# Velocidad del movimiento (afecta qué tan rápido avanza)
@export var speed: float = 0.01


# Lista de nodos PathFollow3D hijos
var followers: Array[PathFollow3D] = []

# Offset individual inicial de cada follower
var offsets: Array[float] = []

# Indica si actualmente se está moviendo
var moviendo := false

# Dirección del movimiento: 1 = adelante, -1 = atrás
var direccion := 0

# Offset objetivo al que se quiere llegar
var objetivo_offset := 0.0

# Offset global que se suma a todos los followers
var offset_global := 0.0


func _ready():
	# Recorre todos los hijos del Path3D
	for child in get_children():
		# Solo guarda los que son PathFollow3D
		if child is PathFollow3D:
			followers.append(child)

	# Si no hay followers, no hace nada
	if followers.is_empty():
		return

	# ==========================
	# DISTRIBUCIÓN INICIAL
	# ==========================
	# Se reparte cada follower de forma uniforme a lo largo del path
	# Ej: si hay 4, spacing = 0.25
	var spacing = 1.0 / followers.size()

	for i in range(followers.size()):
		var offset = spacing * i
		offsets.append(offset)
		# Se establece su posición inicial en el path
		followers[i].progress_ratio = offset

	# Offset global inicia en 0
	offset_global = 0.0


func _process(delta):
	# Solo se mueve si la bandera moviendo está activa
	if moviendo:
		mover(delta)


# ===========================
# FUNCIÓN LLAMADA DESDE FUERA
# ===========================
func recibir_orden(valor: int):
	# Define la dirección según el valor
	if valor == 1:
		direccion = 1       # Avanza
	elif valor == 0:
		direccion = -1      # Retrocede
	else:
		return              # Cualquier otro valor se ignora

	# Calcula el offset objetivo al que debe llegar
	# clamp evita que se salga del rango -1 a 1
	objetivo_offset = clamp(
		offset_global + (porcentaje_movimiento * direccion),
		-1.0,
		1.0
	)

	# Activa el movimiento
	moviendo = true


func mover(delta):
	# Cantidad de avance por frame
	var paso = speed * delta * direccion
	offset_global += paso

	# Si se mueve hacia adelante y ya llegó o pasó el objetivo
	if direccion == 1 and offset_global >= objetivo_offset:
		offset_global = objetivo_offset
		moviendo = false
		emit_signal("movimiento_terminado")

	# Si se mueve hacia atrás y ya llegó o pasó el objetivo
	elif direccion == -1 and offset_global <= objetivo_offset:
		offset_global = objetivo_offset
		moviendo = false
		emit_signal("movimiento_terminado")

	# Actualiza la posición real de los followers
	actualizar_hijos()


# Función asíncrona que mueve y espera a que termine
func mover_y_esperar(valor:int) -> void:
	recibir_orden(valor)
	await movimiento_terminado


func actualizar_hijos():
	# Aplica el offset global a cada follower
	for i in range(followers.size()):
		var nuevo = offsets[i] + offset_global
		
		# fposmod mantiene el valor entre 0 y 1
		# Permite que el movimiento sea circular
		followers[i].progress_ratio = fposmod(nuevo, 1.0)
		

# Devuelve la velocidad en unidades reales del mundo (no normalizada)
func get_velocidad_lineal() -> float:
	# Largo real del path
	var longitud = curve.get_baked_length()
	
	# Convierte speed (relativo) a velocidad real
	return speed * longitud
