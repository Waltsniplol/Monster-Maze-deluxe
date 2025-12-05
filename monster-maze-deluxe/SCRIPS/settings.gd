extends Control

var espera : bool = false
var selec : String

func _ready() -> void:
	for i in $Inputs.get_children():
		i.pressed.connect(Callable(self,"pressed_cambio"))
	$VHS.button_pressed = get_tree().get_first_node_in_group("VHS").visible

func _process(delta: float) -> void:
	#Cambia los Valores
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"), percent_to_db($Pistas/Musica.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Efectos"), percent_to_db($Pistas/Efectos.value))
	#Pitido
	if $Pistas/Musica.has_focus() && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !$Audios/Pitido_Musica.playing:
			$Audios/Pitido_Musica.play()
	else:
		$Audios/Pitido_Musica.stop()
	if $Pistas/Efectos.has_focus() && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if !$Audios/Pitido_Efectos.playing:
			$Audios/Pitido_Efectos.play()
	else:
		$Audios/Pitido_Efectos.stop()
	
	match espera:#Esto es Para Los Botones
		true:
			ESPERA(true)
			$IndControl.visible = true
		_:
			ESPERA(false)
			$IndControl.visible = false

func _input(event) -> void:
	if event is InputEventKey && espera == true:
		CAMBIO(event)
		espera = false

func percent_to_db(volume_percent: float) -> float: #Este es La Ecuacion utilizar para combertir Porcentaje en decibeles
	if volume_percent <= 0:
		return -80.0
	var factor = volume_percent / 100.0
	return 20 * (log(factor) / log(10))

func _on_volver_pressed() -> void: self.visible = !self.visible

func _on_win_full_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vhs_toggled(toggled_on: bool) -> void: GLOBAL.Act_VHS(toggled_on)

func CAMBIO(event) -> void:
	if event.is_pressed():
		cambiar_tecla(selec,event)
		get_node("Inputs/"+str(selec)).text = event.as_text()

func cambiar_tecla(input_action:String, input_event:InputEvent) -> void:
	InputMap.action_erase_events(input_action)
	InputMap.action_add_event(input_action,input_event)

func ESPERA(ok : bool) -> void:
	for i in $Inputs.get_children():
		i.disabled = ok

func pressed_cambio() -> void:
	espera = true
	for i in $Inputs.get_children():
		if i.button_pressed == true:
			selec = i.name
			return
