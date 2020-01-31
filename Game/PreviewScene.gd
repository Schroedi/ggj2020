extends ColorRect
class_name Players_UI

var pname:String setget set_name
var pready:bool setget set_ready
var pcolor:Color setget set_color

func set_name(n:String):
	pname = n
	$PlayerName.text = n

func set_ready(r:bool):
	pready = r
	$LblReady.text = 'Ready' if pready else 'Not Ready'

func set_color(c:Color):
	pcolor = c
	color = c
