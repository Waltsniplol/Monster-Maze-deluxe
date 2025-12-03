extends CanvasLayer


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_reanudar_pressed()

func _on_reanudar_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Menu_Pausa.visible = !$Menu_Pausa.visible
	$Menu_Pausa/Settings.visible = false

func _on_ajustes_pressed() -> void: $Menu_Pausa/Settings.visible = !$Menu_Pausa/Settings.visible

func _on_salir_pressed() -> void: get_tree().quit()
