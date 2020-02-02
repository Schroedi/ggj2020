extends Node2D

const PreviewScene = preload("res://Game/PreviewScene.tscn")
const PlayerScene = preload("res://Game/Player.tscn")

# preview scene references
var previews = []
# player scenes
var players = []


func _ready():
	print('GameScene ready')
	# Only instance the server once. This scene could change, therefore the check.
	if not Airconsole.inst:
		Airconsole.inst = load("res://Game/ACServer.gd").new()
		Airconsole.add_child(Airconsole.inst)
		print('AC addad')
	
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
	var allready = not OS.has_feature('JavaScript') or len(Airconsole.inst.players) > 0
	for i in range(len(Airconsole.inst.players)):
		var p = Airconsole.inst.players[i]
		#print("player: " + str(p))
		var v = previews[i]
		v.pname = p['name']
		players[i].playerId = i
		#v.pcolor = Color(p['devstate']['color'])		 
		v.pready = players[i].isReady or players[i].isAi()
		#players[i].color = v.color
	
	for i in range(4):
		print(players[i].isReady or players[i].isAi())
		allready = allready and (players[i].isReady or players[i].isAi())
	
	if Airconsole.botsOnly:
		allready = true
		
	# all ready?
	if not Airconsole.started and allready and $GameStartTimer.is_stopped():
		$GameStartTimer.start()
	
	# did somebody cancel?
	if not allready:
		Airconsole.started = false
		if not $GameStartTimer.is_stopped():		
			$GameStartTimer.stop() 


func _on_GameStartTimer_timeout():
	$"MainScene/Start bodies".linear_velocity.x = 300
	Airconsole.started =true
	$MainScene/dingTeil.linear_velocity.x = 300
	$MainScene/AudioStreamPlayer.play()
