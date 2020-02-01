extends Node2D

func _input(event):
	if event.is_action_pressed("restart"):
		SceneManager.goto_scene("res://Game/GameScene.tscn")
