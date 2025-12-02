extends RigidBody3D

@export var node_path: NodePath
var target_node: Node3D

func _ready():
	target_node = get_node(node_path)
	custom_integrator = true

func _integrate_forces(state):
	if target_node:
		state.transform = target_node.global_transform
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
