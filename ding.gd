extends Sprite




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position.x += 200 * delta
	
	position.x = fmod(position.x, 1024)


func _on_Area2D_body_entered(body):
	if body.get_parent().type == 'r':
		$r.visible = false
	if body.get_parent().type == 'g':
		$g.visible = false
	if body.get_parent().type == 'b':
		$b.visible = false
	if body.get_parent().type == 'a':
		$a.visible = false
