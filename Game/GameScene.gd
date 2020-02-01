extends Node2D

const PreviewScene = preload("res://Game/PreviewScene.tscn")
const PlayerScene = preload("res://Game/Player.tscn")

# preview scene references
var previews = []
# player scenes
var players = []


func _ready():
	# Only instance the server once. This scene could change, therefore the check.
	if not Airconsole.inst:
		Airconsole.inst = load("res://Game/ACServer.gd").new()
		Airconsole.add_child(Airconsole.inst)
	$PollAirconsole.start()
	players.append($MainScene/p1)
	players.append($MainScene/p2)
	players.append($MainScene/p3)
	players.append($MainScene/p4)


func _process(delta):
	Airconsole.inst.updateInputs()


func _on_PollAirconsole_timeout():
	Airconsole.inst.updatePlayers()
	updatePlayerList()


func updatePlayerList():
	# remove superfluous items
	while previews.size() > Airconsole.inst.players.size():
		previews.pop_back().queue_free()
		#players.pop_back().queue_free()
	
	# fill if new players arrive
	while previews.size() < Airconsole.inst.players.size():
		var v = PreviewScene.instance()
		$UI/PlayerList.add_child(v)
		previews.append(v)
		
		#var p = PlayerScene.instance()
		#add_child(p)
		#players.append(p)
	
	# map player infos to ui and players
	var allready = len(Airconsole.inst.players) > 0
	for i in range(len(Airconsole.inst.players)):
		var p = Airconsole.inst.players[i]
		#print("player: " + str(p))
		var v = previews[i]
		v.pname = p['name']
		#v.pcolor = Color(p['devstate']['color'])
		#v.pready = p['devstate']['isready']
		allready = allready and v.pready
		
		#players[i].color = v.color
		players[i].playerId = i
	
	# all ready?
	if allready and $GameStartTimer.is_stopped():
		$GameStartTimer.start()
	
	# did somebody cancel?
	if not allready and not $GameStartTimer.is_stopped():
		$GameStartTimer.stop()


func _on_GameStartTimer_timeout():
	pass # Replace with function body.
