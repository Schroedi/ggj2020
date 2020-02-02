extends Node2D

var offset = 16
var spawnDings = [
					[0 + offset,['r','b']],
					[2 + offset,['a']],
					[3 + offset,['r']],
					[4 + offset,['r','r2','a']],
					[12 + offset,['r','b']],
					[15 + offset,['g']],
					[16 + offset,['r','b','b2']],
					[18 + offset,['a']],
					[19 + offset,['g','r']],
					[20 + offset,['r','r2','a']],
					[25 + offset,['b','b2']],
					[26 + offset,['b']],
					[28 + offset,['r','b']],
					[31 + offset,['g','a']],
					[34 + offset,['g','b']],	
					[35 + offset,['r','a','b']],	
					[36 + offset,['g','a']],	
					[39 + offset,['a']],	
					[42 + offset,['g','a']],	
					[43 + offset,['r','a','a2']],	
					[44 + offset,['g']],
					[46 + offset,['r']],	
					[47 + offset,['g','a']],	
					[48 + offset,['r','b']],	
					[50 + offset,['g','a']],	
					[54 + offset,['r','b']],	
					[56 + offset,['r','b']],	
					[57 + offset,['r']],	
					[58 + offset,['g','r']],	
					[59 + offset,['r','b']],	
					[64 + offset,['r','a']],	
					[65 + offset,['b','a']],	
					[67 + offset,['r']],	
					[68 + offset,['r','r2','a']],	
					[69 + offset,['b']],	
					[71 + offset,['b','a','b2']],	
					[76 + offset,['r','b','b2']],	
					[77 + offset,['g','a']],	
					[80 + offset,['r']],	
					[81 + offset,['b','a','a2']],	
					[83 + offset,['r','a']],	
					[84 + offset,['r','g','r2','b']],	
					[89 + offset,['b']],	
					[92 + offset,['r','b','b2']],	
					[95 + offset,['g','b']],	
					[107 + offset,['b']],	
					[108 + offset,['a']],	
					[109 + offset,['r']],	
					[111 + offset,['r']],	
					[112 + offset,['r','b','b2']],	
					[113 + offset,['a']],	
					[114 + offset,['g','b']],	
					[115 + offset,['g','a']],	
					[116 + offset,['r','a']],	
					[117 + offset,['g','a']],	
					[118 + offset,['g','b']],	
					[119 + offset,['r','r2','b']],	
					[120 + offset,['r','b','r2','a']],	
					[122 + offset,['g']],	
					[125 + offset,['b']],	
					[126 + offset,['r']],	
					[127 + offset,['g','a']],	
					[128 + offset,['r','a','b']],	
					[129 + offset,['r','b','b2']],	
					[130 + offset,['g']],	
					[131 + offset,['g','a']],	
					[132 + offset,['b','b2']],	
					[133 + offset,['r','a']],	
					[134 + offset,['g','r']],	
					[135 + offset,['b']],	
					[136 + offset,['r','b']],	
					[137 + offset,['r','b']],	
					[138 + offset,['g','b','a']],	
					[141 + offset,['g','r','b']],	
					[142 + offset,['r']],	
					[143 + offset,['b','b2']],	
					[144 + offset,['g','r','a']],	
					[145 + offset,['r','b','r2','a']],	
					[147 + offset,['r','g','r2']],	
					[148 + offset,['g','a']],	
					[149 + offset,['r','g','r2']],	
					[150 + offset,['a']],	
					[151 + offset,['r','r2','b']],	
					[152 + offset,['r','a','b']],	
					[153 + offset,['g','r','b']],	
					[154 + offset,['r','a','b']],	
					[155 + offset,['g','r']],	
					[156 + offset,['r','g','r2']],	
					[158 + offset,['g','g2','a','b']],	
					[159 + offset,['g']],	
					[160 + offset,['g','a']]                                   
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

	var i=0
	for ding in spawnDings:
		var newDing = dingScene.instance()
		newDing.types = ding[1]
		add_child(newDing)
		newDing.position =Vector2(-144*ding[0],768 +fmod(i,2)*rand_range(25.0,40.0))
		i+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Airconsole.started):
		position.x += 300 * delta
