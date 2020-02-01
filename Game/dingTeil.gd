extends Node

var offset = 16
var spawnDings = [
					[0 +offset,['r','b']],
					[2 +offset,['a']],
					[3 +offset,['r']],
					[4 +offset,['r','r2','a']],
					[12+offset,['r','b']],
					[15+offset,['g']],
					[16+offset,['r','b']],
					[18+offset,['a']],
					[19+offset,['g','r']],
					[20+offset,['r','r2','a']],
					[25+offset,['b']],
					[26+offset,['b']],
					[28+offset,['r','b']],
					[31+offset,['g']]                    
				]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dingScene = preload("res://Game/ding.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
#	spawnDings = []
#	for i in range(100):
#		spawnDings.append([i*1, ['a', 'a2', 'r', 'r2', 'g', 'g2', 'b', 'b2']])
	
	
	for ding in spawnDings:
		var newDing = dingScene.instance()
		newDing.types = ding[1]
		add_child(newDing)
		newDing.position =Vector2(-144*ding[0],768)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
