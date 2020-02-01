extends Label


func _ready():
	Airconsole.connect('newScore', self, 'newScore')

func newScore(s):
	text = str(s)
	pass # Replace with function body.

