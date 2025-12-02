extends Node3D
# Nodo sensor que verifica si existe línea directa de visión
# con una luz específica usando un RayCast manual.

@export var target_light: SpotLight3D
# Luz objetivo que se desea detectar (la fuente de iluminación)

@export var polea_central: Node3D
# Referencia a una polea (actualmente no se usa en el código,
# pero probablemente está pensada para interacción futura)


func verificar_luz():
	# Si no se ha asignado una luz objetivo, no se puede verificar
	if not target_light:
		return

	# Punto de inicio del rayo (posición del sensor)
	var from = global_transform.origin

	# Punto final del rayo (posición de la luz)
	var to = target_light.global_transform.origin

	# Acceso al sistema de colisiones del mundo 3D
	var space_state = get_world_3d().direct_space_state

	# Se crea la consulta del rayo desde el sensor hacia la luz
	var query = PhysicsRayQueryParameters3D.create(from, to)

	# El rayo NO detecta áreas
	query.collide_with_areas = false

	# Sí detecta cuerpos físicos
	query.collide_with_bodies = true

	# Ejecuta el RayCast y obtiene el primer impacto
	var result = space_state.intersect_ray(query)

	# Si no hay colisiones entre el sensor y la luz,
	# se considera que la luz llega libremente
	if result.is_empty():
		return 1  # ✅ Visión despejada

	# Si el primer objeto golpeado es la misma luz,
	# significa que nada la bloquea
	elif result["collider"] == target_light:
		return 1  # ✅ Luz visible

	# En caso contrario, hay un objeto bloqueando el rayo
	else:
		return 0  # ❌ Luz obstruida
