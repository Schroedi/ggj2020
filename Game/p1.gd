extends Node2D

export var types = ['r', 'b']
export var audioType = [0, 0]
var type = ""
var soundId = 1
var isReady = false

const sounds = {'g':[ preload("res://Game/SFX/Schraubschlussel.wav"), preload("res://Game/SFX/Rohrzange.wav") ],
'r': [ preload("res://Game/SFX/Hammer_Bass.wav"), preload("res://Game/SFX/Hammer_Eisen.wav") ],
'b': [ preload("res://Game/SFX/Sage.wav"), preload("res://Game/SFX/Axt.wav") ],
'a': [ preload("res://Game/SFX/Spray.wav"), preload("res://Game/SFX/Pinsel.wav") ]}

const fail_sounds = {'p1':preload("res://Game/SFX/AnimalSounds/Pferd.wav"),
					'p2':preload("res://Game/SFX/AnimalSounds/Hahn 1.wav"),
					'p3':preload("res://Game/SFX/AnimalSounds/Hund.wav"),
					'p4':preload("res://Game/SFX/AnimalSounds/Schwein.wav")}

# id in airconsole player array
var playerId = -2 setget set_player_id

var animA:AnimatedSprite
var animB:AnimatedSprite

func isAi():
	return playerId < 0

func set_player_id(i):
	if i == playerId:
		return
	playerId = i
	if isAi():
		# AI
		isReady = true
		$p1/Area2D2/CollisionShape2D.disabled = false

func _ready():
	$Fail.stream = fail_sounds[name]
	
	if name == 'p1':
		$HorseA.visible = true
		$HorseB.visible = true
		$Horse_Head.visible = true
		$Wiggle.root_node = $Horse_Head.get_path()
		
		var anim = $Wiggle.get_animation("Headshake").duplicate()
		var v = anim.track_get_key_value(0, 1)
		# amplitude scaling
		anim.track_set_key_value(0, 1, v * 0.5)
		$Wiggle.remove_animation("Headshake")
		$Wiggle.add_animation("Headshake", anim)
		
		# time offset
		$Wiggle.call_deferred("seek", 0.1)
		
		animA = $HorseA
		animB = $HorseB
	if name == 'p2':
		$PenguinA.visible = true
		$PenguinB.visible = true
		$Penguin_Head.visible = true
		$Wiggle.root_node = $Penguin_Head.get_path()
		
		var anim = $Wiggle.get_animation("Headshake").duplicate()
		var v = anim.track_get_key_value(0, 1)
		# amplitude scaling
		anim.track_set_key_value(0, 1, v * 1)
		$Wiggle.remove_animation("Headshake")
		$Wiggle.add_animation("Headshake", anim)
		
		# time offset
		$Wiggle.call_deferred("seek", 0.1)
		
		animA = $PenguinA
		animB = $PenguinB
	if name == 'p3':
		$DogA.visible = true
		$DogB.visible = true
		$Dog_Head.visible = true
		$Wiggle.root_node = $Dog_Head.get_path()
		
		var anim = $Wiggle.get_animation("Headshake").duplicate()
		var v = anim.track_get_key_value(0, 1)
		# amplitude scaling
		anim.track_set_key_value(0, 1, v*1.5)
		$Wiggle.remove_animation("Headshake")
		$Wiggle.add_animation("Headshake", anim)
		
		# time offset
		$Wiggle.call_deferred("seek", 0.3)
		
		animA = $DogA
		animB = $DogB
	if name == 'p4':
		$PigA.visible = true
		$PigB.visible = true
		$Pig_Head.visible = true
		$Wiggle.root_node = $Pig_Head.get_path()
		
		var anim = $Wiggle.get_animation("Headshake").duplicate()
		var v = anim.track_get_key_value(0, 1)
		# amplitude scaling
		anim.track_set_key_value(0, 1, v * 0.2)
		$Wiggle.remove_animation("Headshake")
		$Wiggle.add_animation("Headshake", anim)
		
		# time offset
		$Wiggle.call_deferred("seek", 0.1)
		
		animA = $PigA
		animB = $PigB
	
	animA.connect("animation_finished", self, "_on_animA_animation_finished")
	animB.connect("animation_finished", self, "_on_animB_animation_finished")
	
	$s1.stream = sounds[types[0]][audioType[0]]
	$s2.stream = sounds[types[1]][audioType[1]]
	$UpdateACInfo.start()
	$Wiggle.play("Headshake")

func _input(event:InputEvent):
	if event.is_action_pressed(name + "a"):
		isReady = true
		playerId = 1
		input_sound(1)
	if event.is_action_pressed(name + "b"):
		isReady = true
		input_sound(2)
		playerId = 1

func input_sound(sId):
	if $p1/AnimationPlayer.is_playing():
		return
	# sound id is 1 or 2
	get_node("s"+str(sId)).play()
	type = types[sId-1]
	soundId = sId-1
	$p1/AnimationPlayer.play("hit")
	if sId == 1:
		animA.play()
	else:
		animB.play()

func collide(t):
	if isAi():
		if not types.has(t):
			return false
		else:
			# for AI set type, otherwise it's already set
			type = t
	
	if t != type:
		$Fail.play()
		print('wrong tool!')
		return false
	
	if types[0] == t:
		$s1.seek(0)
		$s1.play()
	else:
		$s2.seek(0)
		$s2.play()
	
	$p1/Area2D2/CollisionShape2D.set_deferred('disabled', true)
	type = ''
	if isAi():
		$AiDisableTimer.start()
		if types[0] == t:
			animA.play()
		else:
			animB.play()
		
	return true

func update_names():
	var id = int(name.substr(1,1)) - 1
	if Airconsole.inst.players.size() > id:
		$Name.text = Airconsole.inst.players[id]['name']
		$Name.visible = true
		#$Name.text = str(playerId)

func _process(delta):
	# update input
	if OS.has_feature('JavaScript') and not Airconsole.inst.offlineDebug:
		airconsoleInput()

func airconsoleInput():
	if playerId < 0:
		return
	var controller_id = str(Airconsole.inst.players[playerId]['devId'])
	#print(str(Airconsole.inst.players) + str(Airconsole.inst.inputs))
	if Airconsole.inst.inputs.has(controller_id):
		isReady = true
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


func _on_animA_animation_finished():
	animA.frame = 0
	animA.stop()
	pass # Replace with function body.


func _on_animB_animation_finished():
	animB.frame = 0
	animB.stop()
	pass # Replace with function body.
