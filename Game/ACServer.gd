extends Node
class_name ACServer

# inst will hold a reference to the AirConsole client or server.
# This works around the way the problem that we can not specify the Autoload
# type to be two different types in one project.
var inst = null
var started = false
# Run in browser without AriConsole? Set this to true for offline debugging and
# profiling in the browser. Running without a browser is supported by defualt.
var offlineDebug = false

var botsOnly = true

# Input dict with an entry for each player. See updateInputs.
var inputs = {}

# List of player objects. See updatePlayers for details.
# Sample player struct:
# {'devId':  0, 'name': 'p1', 'master': true,  'devstate': {'color':'#ff0000', 'isready':true}}
var players = []


func _ready():
	inst = self
	print('Feature Debug:'+ str(OS.has_feature('JavaScript')) )
	# init AC: register state and AC callbacks on js side
	JavaScript.eval("""
	var airconsole = new AirConsole();
	
	var PlayerInputs = {};
	console.log('Init eval')
	console.log('Inputs: ', PlayerInputs);
	// flag to inform the game of a restart, sent from main player, reset on read (see _process)
	var restart = false;

	airconsole.onMessage = function(device_id, data) {
		if (data.data === undefined) {
			return;
		}
		if (data.data.input !== undefined) {
			PlayerInputs[device_id] = data.data.input;
			//console.log('got message');
			//console.log(data.data);
		  }
		  if (data.data.restart !== undefined) {
			restart = true;
		  }
		};
	airconsole.onCustomDeviceStateChange = function(device_id, state) {
		console.log('statechange: ' + state);
	};
	""", true) # we need the global context here to access AirConsole()


func _process(delta):
	var js = """
		var res = restart;
		restart = false;
		// return
		res
	"""
	var restart = JavaScript.eval(js, false)
	if restart:
		Airconsole.restart()


func updatePlayers():
	# for testing, we return some default players
	
	if not OS.has_feature('JavaScript') or offlineDebug:
		#players = [{'devId':  0, 'name': 'p1', 'master': true,  'devstate': {'color':'#ff0000', 'isready':true}},
		#		   {'devId': -2, 'name': 'p2', 'master': false, 'devstate': {'color':'#00ff00', 'isready':true}}]
		players = []
		return
	
	var js = """
	var devIds = airconsole.getControllerDeviceIds();
	var masterId = airconsole.getMasterControllerDeviceId();
	var players = [];
	devIds.forEach(function(d){
		var pname = airconsole.getNickname(d);
		var devState = airconsole.getCustomDeviceState(d);
		if (devState === undefined) {
			var devState = {color:'#00ff00', isready:true};
		} else {
			console.log('finally we got a state');
		}
		//console.log(devState);
		var ismaster = masterId == d;
		players.push({devId: d, name: pname, master: ismaster, devstate: devState});
		airconsole.message(d, {animal:players.length});
	});
	//console.log(JSON.stringify(players));
	// return
	JSON.stringify(players);
	"""
	var jsRes = JavaScript.eval(js, false)
	players = JSON.parse(jsRes).result


func updateInputs():
	if not OS.has_feature('JavaScript'):
		# simulate 3 player inputs
		inputs = {'0': 0, '1': 0, '2': 0.3}
		return
	var js = """JSON.stringify(PlayerInputs);"""
	var jsRes = JavaScript.eval(js, false)
	inputs = JSON.parse(jsRes).result
	
	# reset inputs to none
	JavaScript.eval("PlayerInputs = {};", false)


func broadcast(msg:String):
	var js = "airconsole.broadcast(%s);" % msg
	JavaScript.eval(js, true)


func sendMsg(devId:int, msg:String):
	var js = "airconsole.message(%d, %s);" % [devId, msg]
	JavaScript.eval(js, true)

func restart():
	Airconsole.started = false
	SceneManager.goto_scene("res://Game/GameScene.tscn")
