extends Node2D

export var types = ['r', 'b']
var type = "b"


const sounds = {'r': preload("res://Game/SFX/BrooklynBD.wav"),
'g': preload("res://Game/SFX/BrooklynBell.wav"),
'a': preload("res://Game/SFX/BrooklynHH.wav"),
'b': preload("res://Game/SFX/BrooklynSound 1.wav")}


# id in airconsole player array
var playerId = -2 setget set_player_id

func isAi():
	return playerId < 0

func set_player_id(i):
	if i == playerId:
		return
	playerId = i
	if isAi():
		# AI
		$p1/Area2D2/CollisionShape2D.disabled = false

func _ready():
	$p1/r.visible = types.has('r')
	$p1/g.visible = types.has('g')
	$p1/b.visible = types.has('b')
	$p1/a.visible = types.has('a')
	
	$s1.stream = sounds[types[0]]
	$s2.stream = sounds[types[1]]
	$UpdateACInfo.start()

func _input(event:InputEvent):
	if event.is_action_pressed(name + "a"):
		input_sound(1)
	if event.is_action_pressed(name + "b"):
		input_sound(2)

func input_sound(soundId):
	if $p1/AnimationPlayer.is_playing():
		return
	# sound id is 1 or 2
	#get_node("s"+str(soundId)).play()
	type = types[soundId-1]
	$p1/AnimationPlayer.play("hit")

func collide(t):
	if isAi():
		if not types.has(t):
			print('wrong tool!')
			return
		else:
			# for AI set type, otherwise it's already set
			type = t	
	
	if t != type:
		print('wrong tool!')
		return
	
	$s1.stream = sounds[t]
	$s1.seek(0)
	$s1.play()
	$p1/Area2D2/CollisionShape2D.set_deferred('disabled', true)
	type = ''
	if isAi():
		$AiDisableTimer.start()
	return true

func update_names():
	var id = int(name.substr(1,1)) - 1
	if Airconsole.inst.players.size() > id:
#		$Name.text = Airconsole.inst.players[id]['name']
		$Name.text = str(playerId)

func _process(delta):
	# update input
	if OS.has_feature('JavaScript') and not Airconsole.inst.offlineDebug:
		airconsoleInput()

func airconsoleInput():
	var controller_id = str(Airconsole.inst.players[playerId]['devId'])
	#print(str(Airconsole.inst.players) + str(Airconsole.inst.inputs))
	if Airconsole.inst.inputs.has(controller_id):
		var sound = int(Airconsole.inst.inputs[controller_id])
		#Airconsole.inst.inputs[controller_id] = 0
		print(name  + ': sound' + str(sound))
		input_sound(sound)


func _on_UpdateACInfo_timeout():
	if not Airconsole.inst:
		return
	update_names()
	pass # Replace with function body.


func _on_AiDisableTimer_timeout():
	$p1/Area2D2/CollisionShape2D.set_deferred('disabled', false)
	pass # Replace with function body.
