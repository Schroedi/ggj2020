extends Node

var spawnDings = [[0,['r','r2','b','b2']] ,[3,['a','a2']] ,[7,['a','a2']],[8,['r','r2','b','b2']]]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dingScene = preload("res://Game/ding.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for ding in spawnDings:		
		var newDing = dingScene.instance()
		newDing.types = ding[1]
		newDing.mov
		add_child(newDing)
		newDing.position =Vector2(-144*ding[0],768)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
