extends Node3D

var Matriz : Dictionary = {
	 0:[0,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,1,0,0],
	99:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
}

func _ready() -> void:
	for i in Matriz.keys():
		for j in range(Matriz[i].size()):
			if Matriz[i][j] == 1:
				print(i,j)
				var B : Node3D = $Escenario/N/LevelBlock.duplicate()
				B.global_position = Vector3(i*2, 0, j*2)
				$Escenario/N.add_child(B)
