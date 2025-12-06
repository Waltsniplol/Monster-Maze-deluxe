extends CharacterBody3D

signal Gamo_Over 

@export var speed = 3.0
@export var trigger_distance = 2.5

var player: Node3D
var jumpscare_instance: Node2D = null

enum Estados {
	Descanso,
	Caminar,
	Buscar
}
var estSelect : Estados = Estados.Descanso

func _ready():
	randomize()
	player = get_tree().get_first_node_in_group("Player") # Ajusta según tu jerarquía
	$Timers/CamEst.wait_time = randi_range(10,30)
	$Timers/CamEst.start()

func _physics_process(_delta):
	match estSelect: #Maquinita de Estados
		Estados.Descanso:
			#$AnimatedSprite3D.play("Descanso")
			pass
		Estados.Caminar: # Es el Mismo Codigo que Buscar
			if $NavigationAgent3D.is_navigation_finished():
				print("Llego")
				_on_cam_est_timeout()
				return
			var next_position = $NavigationAgent3D.get_next_path_position()
			var dir = (next_position - global_transform.origin).normalized()
			if global_transform.origin.distance_to(next_position) > 0.01:
				look_at(next_position, Vector3.UP)
			velocity = dir * speed
			move_and_slide()
		Estados.Buscar:
			$AnimatedSprite3D.play("running")
			# Actualiza la posición objetivo del agente
			$NavigationAgent3D.target_position = player.global_transform.origin
			# Calcula el siguiente punto en el camino
			var next_position = $NavigationAgent3D.get_next_path_position()
			var dir = (next_position - global_transform.origin).normalized()
			# Apuntar hacia el siguiente punto solo si están separados
			if global_transform.origin.distance_to(next_position) > 0.01:
				look_at(next_position, Vector3.UP)
			# Mover usando velocity
			velocity = dir * speed
			move_and_slide()

#Cambia el estado de la maquina de Estados
func _on_cam_est_timeout() -> void: 
	estSelect = randi() % Estados.size()
	if estSelect == Estados.Caminar: # Compruebo si es el mismo para buscar un punto
		$NavigationAgent3D.target_position = NavigationServer3D.map_get_random_point($NavigationAgent3D.get_navigation_map(), 1 ,1) #Aqui debo poner que Elija un punto aletorio
	$Timers/CamEst.wait_time = randi_range(10,30)

func _on_game_over_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("Gamo_Over")

func _on_detectado_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		estSelect = Estados.Buscar
