extends Node3D

func _on_meta_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		GLOBAL.MomHist = 1
		get_tree().change_scene_to_file("res://SCENE/cinematic.tscn")
