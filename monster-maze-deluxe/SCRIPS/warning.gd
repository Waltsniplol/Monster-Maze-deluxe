extends Control

var waiting_for_enter := true

func _ready() -> void:
	$Texto.text = "WARNING

This game contains intense flashing lights, 
loud sounds, sudden jump scares, and other potentially distressing 
content. If you have a history of heart conditions, epilepsy
or are sensitive to flashing lights or loud noises, we strongly 
advise that you do not play this game. Player discretion is strongly
recommended, and anyone who feels unwell while playing
should stop immediately.

Good luck.\nPress ENTER to continue."

func _process(_delta: float) -> void:
	if waiting_for_enter and Input.is_action_just_pressed("ui_accept"):
		waiting_for_enter = false
		fade_out_and_start()

func fade_out_and_start() -> void:
	var tween = create_tween()
	tween.tween_property($Texto, "modulate:a", 0.0, 1.0)
	tween.tween_callback(Callable(self, "start_game"))

func start_game() -> void:
	get_tree().change_scene_to_file("res://SCENE/MENU.tscn")
