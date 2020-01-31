extends Node

### Client code
var nextMsg = {}

var secondsTilNextSend = 0.0
var sendQueued = false

func _ready():
	JavaScript.eval("""
	var ac = new AirConsole();
	ac.setCustomDeviceState({foo:'bar'});
	var screen = 'mainmenu'
	var place = 0
	// Listen for messages
	ac.onMessage = function(device_id, data) {
		console.log('ctrl recv: ', data);
		if (data.screen !== undefined) {
			screen = data.screen;
		}
		if (data.place !== undefined) {
			place = data.place;
		}
	};
	""", true)


func _process(delta):	
	if not OS.has_feature('JavaScript'):
		return
	# poll for screen change
	var js = "screen"
	var new_screen = JavaScript.eval(js, false)
#	if new_screen != screen:
#		screen = new_screen
#		if screen == 'mainmenu':
#			#get_tree().change_scene("res://PlayerPreviewScreen.tscn")
#			SceneManager.goto_scene("res://PlayerPreviewScreen.tscn")
#		elif screen == 'control':
#			#get_tree().change_scene("res://Control.tscn")
#			SceneManager.goto_scene("res://Control.tscn")
#		elif screen == 'game_over':
#			SceneManager.goto_scene("res://GameOver.tscn")


func mergeDicts(old:Dictionary, new:Dictionary):
	for k in new.keys():
		old[k] = new[k]
	return old


func messageScreen(msg:Dictionary):
	# send a rate limited message to the screen
	# this replaces the value of unsent messages with the same key
	nextMsg = mergeDicts(nextMsg, msg)
	# did we already queue the next send via yield?
	if sendQueued:
		return
	# rate limit
	if secondsTilNextSend > 0:
		sendQueued = true
		yield(get_tree().create_timer(secondsTilNextSend), "timeout")
	
	# the actual work
	var js = "ac.message(AirConsole.SCREEN, %s);" % JSON.print(msg)
	JavaScript.eval(js, false)
	
	# reset everything for next sending
	nextMsg = {}
	secondsTilNextSend = 1.01/10 # no more than 10 msges per second
	sendQueued = false


func isMaster():
	if not OS.has_feature('JavaScript'):
		return true
	
	var js = "ac.getMasterControllerDeviceId() == ac.getDeviceId()"
	var res = JavaScript.eval(js, false);
	return res


func getPlace():
	if not OS.has_feature('JavaScript'):
		return str(1)
	
	var js = "place"
	var place = JavaScript.eval(js, false);
	return place
