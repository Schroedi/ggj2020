extends Node2D

export var types = ['r', 'b']
var type = "b"

const sounds = {'r': preload("res://Game/SFX/BrooklynSound 1.wav"),
'g': preload("res://Game/SFX/BrooklynBell.wav"),
'a': preload("res://Game/SFX/BrooklynBD.wav"),
'b': preload("res://Game/SFX/BrooklynHH.wav")}

# 1 or 2
var sound = 0

func _ready():
	$p1/r.visible = types.has('r')
	$p1/g.visible = types.has('g')
	$p1/b.visible = types.has('b')
	$p1/a.visible = types.has('a')
	
	$s1.stream = sounds[types[0]]
	$s2.stream = sounds[types[1]]

func _input(event:InputEvent):
	if $p1/AnimationPlayer.is_playing():
		return
	
	if event.is_action_pressed(name + "a"):
		sound = 1
		$s1.play()
		type = types[0]
		$p1/AnimationPlayer.play("hit")
	if event.is_action_pressed(name + "b"):
		sound = 2
		$s2.play()
		type = types[1]
		$p1/AnimationPlayer.play("hit")

func play_sound(t):
	$s1.stream = sounds[t]
	$s1.play()
#	if sound == 1:
#		$s1.play()
#	if sound == 2:
#		$s2.play()
	pass
