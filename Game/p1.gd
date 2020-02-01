extends Sprite

export var types = ['r', 'b']
var type = "b"

# 1 or 2
var sound = 0

func _ready():
	$r.visible = types.has('r')
	$g.visible = types.has('g')
	$b.visible = types.has('b')
	$a.visible = types.has('a')

func _input(event:InputEvent):
	if $AnimationPlayer.is_playing():
		return
	
	if event.is_action_pressed(name + "a"):
		sound = 1
		$s1.play()
		type = types[0]
		$AnimationPlayer.play("hit")
	if event.is_action_pressed(name + "b"):
		sound = 2
		$s2.play()
		type = types[1]
		$AnimationPlayer.play("hit")

func play_sound():
#	if sound == 1:
#		$s1.play()
#	if sound == 2:
#		$s2.play()
	pass
