extends Node2D

func _input(event):
	if event.is_action_pressed("restart"):
		Airconsole.started = false
		SceneManager.goto_scene("res://Game/GameScene.tscn")
