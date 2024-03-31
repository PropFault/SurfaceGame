extends Node

@onready var stand = $Stand
@onready var walk = $Walk
@onready var cur = stand

var walking = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if walking:
		cur = walk
	else:
		cur = stand
	cur.run(delta)
