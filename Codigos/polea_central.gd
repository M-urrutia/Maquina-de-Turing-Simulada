extends Node3D
# Nodo principal que controla la animación de giro de una polea central
# y opcionalmente dos poleas secundarias sincronizadas.

# Referencias a las poleas laterales
@export var polea_izquierda : Node3D
@export var polea_derecha  : Node3D

# Ángulo máximo de giro en grados (positivo o negativo)
@export var giro_max_deg : float = 90.0

# Factores multiplicadores para el giro de las poleas laterales
# Permiten que giren más lento, más rápido o en sentido distinto
@export var factor_izquierda : float = 1.0
@export var factor_derecha   : float = 1.0

# Duración de la animación de giro (ida y vuelta)
@export var tiempo_animacion : float = 1.0

# Tiempo que permanece detenido en la posición final
@export var tiempo_espera : float = 1.0


# Evita que se inicien múltiples giros al mismo tiempo
var girando := false


func girar(valor:int):
	# Si ya está girando, ignora nuevas órdenes
	if girando:
		return

	girando = true

	# Convierte los grados a radianes
	# Si valor == 1, gira en sentido positivo
	# Si no, gira en sentido contrario
	var angulo_rad = deg_to_rad(giro_max_deg if valor == 1 else -giro_max_deg)

	# Tween para la animación de ida
	var tween := create_tween()
	tween.set_parallel(true) 
	# set_parallel(true) permite que todas las animaciones ocurran simultáneamente

	# Giro del nodo principal en el eje Z
	tween.tween_property(self, "rotation:z", angulo_rad, tiempo_animacion)

	# Giro sincronizado de la polea izquierda
	if polea_izquierda:
		tween.tween_property(
			polea_izquierda,
			"rotation:z",
			angulo_rad * factor_izquierda,
			tiempo_animacion
		)

	# Giro sincronizado de la polea derecha
	if polea_derecha:
		tween.tween_property(
			polea_derecha,
			"rotation:z",
			angulo_rad * factor_derecha,
			tiempo_animacion
		)

	# Espera a que el giro de ida termine
	await tween.finished

	# Mantiene la posición final por un tiempo definido
	await get_tree().create_timer(tiempo_espera).timeout


	# Tween para la animación de retorno a 0°
	var retorno := create_tween()
	retorno.set_parallel(true)

	# Regreso del nodo principal a su rotación original
	retorno.tween_property(self, "rotation:z", 0.0, tiempo_animacion)

	# Regreso de poleas laterales
	if polea_izquierda:
		retorno.tween_property(polea_izquierda, "rotation:z", 0.0, tiempo_animacion)
	if polea_derecha:
		retorno.tween_property(polea_derecha, "rotation:z", 0.0, tiempo_animacion)

	# Espera a que el retorno termine
	await retorno.finished

	# Libera el bloqueo de animación
	girando = false
