extends Node3D

const TRAVEL_TIME := 0.3
const MOVE_DISTANCE := 2.0
const TURN_ANGLE := PI / 2

@onready var front_ray: RayCast3D = $RayCast/FrontRay
@onready var back_ray: RayCast3D = $RayCast/BackRay
@onready var animation: AnimationPlayer = $Animation

#Agregar Dash

var tween: Tween

func _physics_process(_delta):
	if tween and tween.is_running():
		return
	
	if Input.is_action_pressed("forward") and not front_ray.is_colliding():
		move_local(-transform.basis.z * MOVE_DISTANCE)
	
	elif Input.is_action_pressed("back") and not back_ray.is_colliding():
		move_local(transform.basis.z * MOVE_DISTANCE)
	
	elif Input.is_action_pressed("left"):
		rotate_y_local(TURN_ANGLE)
	
	elif Input.is_action_pressed("right"):
		rotate_y_local(-TURN_ANGLE)
	
	elif Input.is_action_pressed("Dash") && $Timer/Can_Dash.is_stopped() && not $RayCast/DashRay.is_colliding(): #Dash
		move_local(-transform.basis.z * MOVE_DISTANCE, 2)
		$Timer/Can_Dash.start()

func move_local(direction: Vector3, Dash : int = 1):#Resicle el Mismo codigo solo agregando un valor para Dash
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_transform := transform.translated(direction * Dash)
	tween.tween_property(self, "transform", target_transform, TRAVEL_TIME)
	animation.play("headbob")

func rotate_y_local(angle: float):
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var target_basis := transform.basis.rotated(Vector3.UP, angle)
	tween.tween_property(self, "transform:basis", target_basis, TRAVEL_TIME)
	animation.play("change")
