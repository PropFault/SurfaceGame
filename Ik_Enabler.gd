@tool
extends Node
@export var ik_nodes: Array[SkeletonIK3D]= []

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in ik_nodes:
		node.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
