extends Control

# Obtener todos los botones hijos del VBoxContainer
@onready var buttons := $VBoxContainer.get_children()
# Nodo de audio para el sonido de hover
@onready var hover_player := $hover_player

# Configuración del hover
var hover_offset := 0.03
var tween_duration := 0.15

func _ready():
	# Conectar señales de hover para cada botón
	for btn in buttons:
		btn.mouse_entered.connect(func() -> void:
			_on_button_hover(btn))
		btn.mouse_exited.connect(func() -> void:
			_on_button_unhover(btn))

func _on_button_hover(btn):
	# Reproducir sonido de hover
	if hover_player.playing:
		hover_player.stop()
	hover_player.play()

	# Manejar tween existente
	var t = null
	if btn.has_meta("hover_tween"):
		t = btn.get_meta("hover_tween")
		if t != null:
			t.kill()

	# Crear nuevo tween para escalar el botón
	var tween = create_tween()
	btn.set_meta("hover_tween", tween)

	tween.tween_property(
		btn,
		"scale",
		Vector2(1.0 - hover_offset, 1.0 - hover_offset),
		tween_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_button_unhover(btn):
	# Manejar tween existente
	var t = null
	if btn.has_meta("hover_tween"):
		t = btn.get_meta("hover_tween")
		if t != null:
			t.kill()

	# Crear tween para volver a la escala original
	var tween = create_tween()
	btn.set_meta("hover_tween", tween)

	tween.tween_property(
		btn,
		"scale",
		Vector2(1.0, 1.0),
		tween_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
