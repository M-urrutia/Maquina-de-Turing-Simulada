extends Node3D

@export var follow_speed := 4.0
@export var follow_time := 3.0
@export var stop_time := 3.0
@export var rigid_body_path: NodePath
@export var attraction_strength := 10.0   # qué tan fuerte sigue el camino
@export var damping_strength := 8.0        # frenado al detenerse

var rb: RigidBody3D
var pf: PathFollow3D
var following := true
var timer := 0.0

func _ready():
	pf = get_parent() as PathFollow3D
	rb = get_node(rigid_body_path)

func _physics_process(delta):
	timer += delta

	# Cambiar de estados (seguir/detenerse)
	if following and timer >= follow_time:
		following = false
		timer = 0.0

	elif not following and timer >= stop_time:
		following = true
		timer = 0.0

	if following:
		# Avanza por el Path
		pf.progress += follow_speed * delta

		# Posición objetivo
		var target = pf.global_transform.origin
		var current = rb.global_transform.origin

		# Vector hacia el path
		var dir = (target - current)
		var dist = dir.length()

		if dist > 0.001:
			dir = dir.normalized()

			# Aplicar fuerza que lo jala hacia el path
			rb.apply_central_force(dir * attraction_strength * dist)
	else:
		# Frenado suave mientras está detenido
		rb.apply_central_force(-rb.linear_velocity * damping_strength)
