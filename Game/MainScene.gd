extends Node2D

func _input(event):
	if event.is_action_pressed("restart"):
		Airconsole.restart()

func _process(delta):
	$"Background_Scrollband".region_rect.position.x -= delta * 300
	$"Wolken/Wolken_1".region_rect.position.x -= delta * 23
	$"Wolken/Wolken_2".region_rect.position.x -= delta * 32
