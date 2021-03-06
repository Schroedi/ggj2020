extends Node2D

func _input(event):
	if event.is_action_pressed("restart"):
		Airconsole.restart()

func _process(delta):
	var x
	if Airconsole.started:
		x = $"Background_Scrollband".region_rect.position.x
		$"Background_Scrollband".region_rect.position.x = fmod(x + delta * -300, 1920)
	
	x = $"Wolken/Wolken_1".region_rect.position.x 
	$"Wolken/Wolken_1".region_rect.position.x = fmod(x + delta * 23, 1920)
	
	x = $"Wolken/Wolken_2".region_rect.position.x
	$"Wolken/Wolken_2".region_rect.position.x = fmod(x + delta * 32, 1920)


func _on_Ende_area_entered(area):
	var remTeile = area.get_parent().types.size()
	Airconsole.score -= remTeile * 5
	pass # Replace with function body.


func _on_Delete_area_entered(area):
	area.get_parent().queue_free()
	pass # Replace with function body.
