extends Node2D

# movement speed
export var turnSpeed = 5
export var color:Color setget set_color
func set_color(c:Color):
	color = c
	$Paddle.modulate = c

# id in airconsole player array
var playerId = -1

# target sent from the player as input
var targetRotation = PI / 2.0


func _process(delta):
	# update input
	if OS.has_feature('JavaScript') and not Airconsole.inst.offlineDebug:
		airconsoleInput()
	else:
		desktopInput(delta)
	
	move(delta)
	$Paddle/Node2D/Label.text = str(playerId)


func airconsoleInput():
	var controller_id = str(Airconsole.inst.players[playerId]['devId'])
	#print(str(Airconsole.inst.players) + str(Airconsole.inst.inputs))
	if Airconsole.inst.inputs.has(controller_id):
		targetRotation = Airconsole.inst.inputs[controller_id]


func desktopInput(delta:float):
	# not really good, but works for testing
	if Input.is_key_pressed(KEY_A):
		targetRotation -= delta * 5
	elif Input.is_key_pressed(KEY_D):
		targetRotation += delta * 5


func move(delta:float):
	rotation = lerp_angle(rotation, targetRotation, delta * turnSpeed)
