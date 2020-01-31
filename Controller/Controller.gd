extends Control


var isReady:bool = false setget set_ready
var color:Color = Color(.8, .2, .2) setget set_color
signal ColorChanged

var devState = {'color':'#11aa11', 'isready':'false'}

var secondsTilNextSend = 0.0
var sendQueued = false

func _ready():
	# Only instance the client once. This scene could change, therefore the check.
	if not Airconsole.inst:
		Airconsole.inst = load("res://Controller/ACClient.gd").new()
		Airconsole.add_child(Airconsole.inst)
	# send initial device state
	setDevState("foo", "bar")
	
	

func _process(delta):
	secondsTilNextSend = max(0, secondsTilNextSend - delta)

#func getDevState():
#	var js = "ac.getCustomDeviceState(ac.getDeviceId())"
#	var jsRes = JavaScript.eval(js, false)
#	return JSON.parse(jsRes).result


func setDevState(key, value):
	devState[key] = value
	if sendQueued:
		return
	
	# rate limit
	if secondsTilNextSend > 0:
		sendQueued = true
		yield(get_tree().create_timer(secondsTilNextSend), "timeout")
	var js = "ac.setCustomDeviceState(%s)" % JSON.print(devState)
	JavaScript.eval(js, true)
	#('sent state: ' + JSON.print(devState))
	secondsTilNextSend = 1.01/10 # no more than 10 msges per second
	sendQueued = false


func set_color(v:Color):
	color = v
	setDevState('color', color.to_html(false))
	emit_signal("ColorChanged")


func set_ready(v:bool):
	isReady = v
	setDevState('isready', v)


func _on_JoystickSendTimer_timeout():
	var js = "ac.setCustomDeviceStateProperty('foo', 'bar');"
	JavaScript.eval(js, true)
	#Airconsole.inst.messageScreen({'input': $Joystick.output.angle()})
