extends Control

@export var type_speed: float = 0.05                  # segundos por letra
@export var type_sound: AudioStream                   # sonido por letra (ogg)
var type_sound_player: AudioStreamPlayer              # reproductor interno

var lines = [
	"Roll up! Roll up!",
	"See the amazing Tyrannosaurus Rex, King of the Dinosaurs!",
	"In his lair, perfectly preserved in silicon since prehistoric times!",
	"Brought to you for your entertainment and exhilaration!",
	"I am Gozo the Clown, a pleasure to meet you!",
	"So… what do you say?",
	"Are you ready to meet 'REX'?"
]
var current_line = 0
var dialogue_finished = false
var typing = false
var is_bouncing = false   # controla el rebote del payaso

# Referencia al RichTextLabel
var dialogue_label: RichTextLabel
# Referencia al payaso AnimatedSprite2D
var clown_sprite: AnimatedSprite2D

# Variables para el rebote del payaso
var clown_base_pos: Vector2
var clown_bounce_timer: float = 0
var clown_bounce_height: float = 1
var clown_bounce_speed: float = 50

func _ready():
	# Obtener referencias
	dialogue_label = $DialogueLabel
	assert(dialogue_label != null, "No se encontró DialogueLabel")

	clown_sprite = $ClownSprite
	clown_sprite.scale = Vector2(0.145, 0.145)
	clown_base_pos = clown_sprite.position
	clown_sprite.play("idle")  # animación inicial

	# Crear AudioStreamPlayer interno para el sonido por letra
	if type_sound:
		type_sound_player = AudioStreamPlayer.new()
		type_sound_player.stream = type_sound
		type_sound_player.volume_db = -5
		add_child(type_sound_player)  # asegurarse de agregar al árbol antes de reproducir

	# Ocultar botones al inicio
	$EnterButton.visible = false
	$ExitButton.visible = false
	$EnterButton.pressed.connect(Callable(self, "_on_enter_pressed"))
	$ExitButton.pressed.connect(Callable(self, "_on_exit_pressed"))

	# Mostrar la primera línea
	await _type_line(lines[current_line])

func _input(event):
	if event.is_action_pressed("ui_accept") and not dialogue_finished:
		if typing:
			# Detener sonido y rebote
			if type_sound_player:
				type_sound_player.stop()
			typing = false
			is_bouncing = false
			clown_sprite.play("idle")
			# Mostrar toda la línea instantáneamente
			dialogue_label.clear()
			dialogue_label.add_text(lines[current_line])
		else:
			current_line += 1
			if current_line < lines.size():
				await _type_line(lines[current_line])
			else:
				dialogue_finished = true
				$EnterButton.visible = true
				$ExitButton.visible = true
				clown_sprite.play("idle")

# Función typewriter letra por letra
func _type_line(text: String) -> void:
	typing = true
	is_bouncing = true
	clown_sprite.play("talking")
	dialogue_label.clear()

	for letter in text:
		# Si typing fue cancelado (por skip), mostramos todo y salimos
		if not typing:
			dialogue_label.clear()
			dialogue_label.add_text(text)
			break

		dialogue_label.append_text(letter)

		# Sonido por letra solo si typing sigue activo
		if type_sound_player and typing:
			type_sound_player.stop()
			type_sound_player.play()

		await get_tree().process_frame
		await get_tree().create_timer(type_speed).timeout

	typing = false
	is_bouncing = false
	clown_sprite.play("idle")

func _on_enter_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/level.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/MENU.tscn")

func _process(_delta: float) -> void:
	# Rebote del payaso solo mientras habla
	if is_bouncing:
		clown_bounce_timer += _delta * clown_bounce_speed
		clown_sprite.position.y = clown_base_pos.y - sin(clown_bounce_timer) * clown_bounce_height
	else:
		clown_sprite.position.y = clown_base_pos.y
