extends RigidBody3D

var distancia := 3.0

func teletransportar_atras():
	var transform_actual = global_transform

	# vector atrás según la orientación
	var atras = -transform_actual.basis.z.normalized()

	# nueva posición
	transform_actual.origin += atras * distancia

	# aplicar directamente al servidor de física (funciona aunque esté sleeping)
	PhysicsServer3D.body_set_state(
		self.get_rid(),
		PhysicsServer3D.BODY_STATE_TRANSFORM,
		transform_actual
	)

	# opcional: resetear velocidades
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
