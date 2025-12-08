extends CanvasLayer

@onready var Rex : CharacterBody3D

func _ready() -> void: Rex = get_tree().get_first_node_in_group("Rex")

func _process(delta: float) -> void:
	match Rex.estSelect:
		Rex.Estados.Descanso:
			$IndRex/Text.text = "Rex esta Descansado"
		Rex.Estados.Caminar:
			$IndRex/Text.text = "Rex esta dando un paseo"
		Rex.Estados.Buscar:
			$IndRex/Text.text = "Rex te esta Buscando"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") && !$Audio/Jumpscare.playing:
		_on_reanudar_pressed()

func _on_rex_gamo_over() -> void: #Esta Funcion es llamada por una cenal cuando el personaje muere
	$Audio/Jumpscare.process_mode = Node.PROCESS_MODE_ALWAYS
	$Audio/Jumpscare.play()
	get_tree().paused = true
	await $Audio/Jumpscare.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

#Menu de Pausa {
func _on_reanudar_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Menu_Pausa.visible = !$Menu_Pausa.visible
	$Menu_Pausa/Settings.visible = false
func _on_ajustes_pressed() -> void: $Menu_Pausa/Settings.visible = !$Menu_Pausa/Settings.visible
func _on_salir_pressed() -> void: get_tree().quit()
# } Menu de Pausa 
