extends CharacterBody2D

var tween: Tween
var UltMovimiento : Vector2 = Vector2.ZERO
var CanMove : bool = true

func _input(event: InputEvent) -> void:
	if tween and tween.is_running():
		return
	if CanMove:
		if Input.is_action_just_pressed("right"):
			Movimiento(Vector2(16,0))
		elif Input.is_action_just_pressed("left"):
			Movimiento(Vector2(-16,0))
		elif Input.is_action_just_pressed("back"):
			Movimiento(Vector2(0,16))
		elif Input.is_action_just_pressed("forward"):
			Movimiento(Vector2(0,-16))
		elif Input.is_action_just_pressed("Dash"):
			Movimiento(UltMovimiento, 2)

func Movimiento(Distacia : Vector2 , Dash : int = 1):
	UltMovimiento = Distacia
	Distacia.x *= Dash
	Distacia.y *= Dash
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", global_position + Distacia, 0.05)
