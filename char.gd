extends CharacterBody2D
@export var head: Node2D
@export var arms: Node2D
@export var legs: Node2D
@export var look_target: Node2D
var move_inp : Vector2
	
func set_move_inp(input): 
	move_inp = input
	
func _process(delta):
	self.velocity = move_inp * delta;
	self.move_and_slide();
	# look
	head.look_at(look_target.position);
	arms.look_at(look_target.position);
	legs.look_at(self.global_position + move_inp)
