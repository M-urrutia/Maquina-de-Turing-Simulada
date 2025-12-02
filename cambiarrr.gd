extends Area3D

var body_inside: RigidBody3D = null

func _ready():
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _on_enter(body):
	if body is RigidBody3D:
		body_inside = body

func _on_exit(body):
	if body == body_inside:
		body_inside = null

func _process(delta):
	if Input.is_action_just_pressed("cambiar_estado"):
		if body_inside:
			body_inside.teletransportar_atras()
