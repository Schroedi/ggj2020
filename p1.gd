extends Sprite

export var type = "b"
export var input = "ui_accept"

func _input(event:InputEvent):
	if event.is_action_pressed(input):
#		if $AnimationPlayer.is_playing():
#			$AnimationPlayer.seek(0, true)
		$AnimationPlayer.play("hit")
		#$p1/s1.play()
