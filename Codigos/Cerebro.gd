extends Node3D
# Nodo principal que controla la lógica de la "máquina de Turing" simulada.

@onready var EstadoActual = 0
# Estado actual de la máquina (nodo del autómata finito)

@onready var polea = $Poleas/PoleaCentral
# Referencia a la polea central que probablemente escribe o modifica el bit

@onready var cinta = $Estructura/Cinta/Path3D
# Referencia a la cinta (la "tape" de la máquina de Turing)

@onready var sensor = $Sensor
# Sensor que lee el valor del bit actual en la cinta

@onready var prendido = false
# Indica si la máquina está activa o apagada


# =========================
# CONTROL DE INICIO
# =========================
func _input(event):
	if Input.is_action_just_pressed("start_turing") and prendido == false:
		prendido = true
		EstadoActual = 0
		# Reinicia al estado inicial
		ciclo_turing()
		# Inicia el ciclo principal


# =========================
# CICLO PRINCIPAL
# =========================
func ciclo_turing():
	var bit_leido = 0

	# Bucle principal mientras la máquina esté encendida
	while(prendido == true):

		# --- LECTURA DEL BIT ---
		bit_leido = sensor.verificar_luz()
		# Obtiene 0 o 1 desde el sensor óptico

		print("Estado actual es ", EstadoActual)
		print("El bit leido es ", bit_leido)

		# --- AUTÓMATA FINITO ---
		match EstadoActual:

			# ================= ESTADO 0 =================
			0:
				if bit_leido == 0: 
					await polea.girar(0)              # Escribe 0
					await cinta.mover_y_esperar(1)   # Mueve cinta a la derecha
					EstadoActual = 5                 # Transición al estado 5
				else: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 1

			# ================= ESTADO 1 =================
			1:
				if bit_leido == 0: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 2 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 1

			# ================= ESTADO 2 =================
			2:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)  # Mueve a la izquierda
					EstadoActual = 3 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 2

			# ================= ESTADO 3 =================
			3:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 3 
				else: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 4

			# ================= ESTADO 4 (HALT) =================
			4:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 4
					prendido = false   # Máquina se apaga
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 4
					prendido = false

			# ================= ESTADO 5 =================
			5:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 4 
				else: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 6

			# ================= ESTADO 6 =================
			6:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 7 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 6

			# ================= ESTADO 7 =================
			7:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 8 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(1)
					EstadoActual = 7

			# ================= ESTADO 8 =================
			8:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 4 
				else: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 9

			# ================= ESTADO 9 =================
			9:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 10 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(0)
					EstadoActual = 9

			# ================= ESTADO 10 =================
			10:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(0)
					EstadoActual = 4 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(0)
					EstadoActual = 11

			# ================= ESTADO 11 =================
			11:
				if bit_leido == 0: 
					await polea.girar(0)
					await cinta.mover_y_esperar(1)
					EstadoActual = 5 
				else: 
					await polea.girar(1)
					await cinta.mover_y_esperar(0)
					EstadoActual = 11


			# ESTADO INVALIDO
			_:
				print("Valor desconocido")
				EstadoActual = 4
