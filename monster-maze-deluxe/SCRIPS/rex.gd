extends CharacterBody3D

@export var speed = 3.0
@export var trigger_distance = 2.5

var player: Node3D
var jumpscare_instance: Node2D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D

#Aqui se le Debe agregar un camino usando navitionagen3D


func _ready():
	player = get_parent().get_node("Player") # Ajusta según tu jerarquía
	nav_agent.target_position = player.global_transform.origin

func _physics_process(_delta):
	if not player:
		return

	# Actualiza la posición objetivo del agente
	nav_agent.target_position = player.global_transform.origin

	# Calcula el siguiente punto en el camino
	var next_position = nav_agent.get_next_path_position()
	var dir = (next_position - global_transform.origin).normalized()

	# Apuntar hacia el siguiente punto solo si están separados
	if global_transform.origin.distance_to(next_position) > 0.01:
		look_at(next_position, Vector3.UP)

	# Mover usando velocity
	velocity = dir * speed
	move_and_slide()

	# Reproducir animación de correr si se mueve
	if dir.length() > 0.1:
		if animated_sprite.animation != "running":
			animated_sprite.play("running")
	else:
		animated_sprite.stop()
