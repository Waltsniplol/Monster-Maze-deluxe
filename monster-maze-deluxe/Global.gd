extends Node

var MomHist : int = 0 #Es para Saber en que momento de la historia estas
var MPDinoM : int = 0 #Puntuacion Minijuego

func Act_VHS(AON : bool) -> void:
	get_tree().get_first_node_in_group("VHS").visible = AON
