extends Node3D
@export var material: Material
@onready var controller = $Controller
var geometry: Array[GeometryInstance3D]
var look_dir: Vector2
var move_in: Vector2
var hp: int = 100

@onready var dead = $States/Dead
@onready var alive = $States/Alive
@onready var state = alive



func _collect_geometry(cursor: Node):
	if cursor is GeometryInstance3D:
		geometry.append(cursor)
	for child in cursor.get_children():
		_collect_geometry(child)

func _ready():
	_collect_geometry(self)
	for geo in geometry:
		geo.material_override = material

func _process(delta):
	if hp < 0:
		state = dead
	else:
		state = alive
	state.run(delta)
	
