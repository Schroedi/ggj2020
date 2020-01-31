extends Node2D

# movement speed
export var turnSpeed = 5
export var color:Color setget set_color
func set_color(c:Color):
	color = c
	$Paddle.modulate = c

# id in airconsole player array
var playerId = -1

# target sound
var targetSound:int = 0


func _process(delta):
	# update input
	if OS.has_feature('JavaScript') and not Airconsole.inst.offlineDebug:
		airconsoleInput()
	else:
		desktopInput(delta)
	$Paddle/Node2D/Label.text = str(playerId)
	
	# play sound
	if targetSound == 1:
		$S1.play(0)
	elif targetSound == 2:
		$S2.play(0)
		
	targetSound = 0


func airconsoleInput():
	var controller_id = str(Airconsole.inst.players[playerId]['devId'])
	#print(str(Airconsole.inst.players) + str(Airconsole.inst.inputs))
	if Airconsole.inst.inputs.has(controller_id):
		targetSound = int(Airconsole.inst.inputs[controller_id])
		print(targetSound)


func desktopInput(delta:float):
	# not really good, but works for testing
	if Input.is_key_pressed(KEY_A):
		targetSound = 1
	elif Input.is_key_pressed(KEY_D):
		targetSound = 2

