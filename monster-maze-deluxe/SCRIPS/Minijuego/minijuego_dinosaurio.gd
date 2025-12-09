extends Node2D

var NewOBS : Area2D
var punto : int = 0
var velocidad : float = 128 

func _ready() -> void:
	Add_OBS()

func _physics_process(delta: float) -> void:
	$UI/Puntos.text = str(punto)
	$UI/MaxPuntos.text = "HI "+str(GLOBAL.MPDinoM)
	if NewOBS != null:
		NewOBS.global_position.x -= velocidad * delta
		if NewOBS.global_position.x < -10:
			NewOBS.queue_free()
			Add_OBS()
	if punto >= GLOBAL.MPDinoM:
		GLOBAL.MPDinoM = punto

func _on_obstaculo_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().paused = true
		$UI/Game_Over.visible = true

func _on_salto_logrado_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		velocidad += 8
		punto += 10

func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func Add_OBS() -> void:
	$Obj/Obstaculo.global_position.x = randf_range(334, 400)
	NewOBS = $Obj/Obstaculo.duplicate()
	NewOBS.get_node("AnimationPlayer").play(str(randi() % 4))
	$Obj.add_child(NewOBS)
