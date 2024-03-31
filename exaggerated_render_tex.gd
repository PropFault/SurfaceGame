@tool
extends Sprite2D

@export var primarySourceTexture : Texture2D
@export var minFps = 10.0
@export var maxImageDelta = 0.1
var _timer = 0.0

func _update_image(s: Image):
	self.texture.set_image(s)
	_timer = 0.0
	

func _process(delta):
	if(self.texture == null):
		self.texture = ImageTexture.new()
	var s = primarySourceTexture.get_image()
	var c = self.texture.get_image();
	if(s == null):
		_update_image(s)
		return
	var metrics = s.compute_image_metrics(c, true)
	var mean = metrics["mean"]
	print(mean)
	if(mean > maxImageDelta):
		_update_image(s)
	if(_timer > (1.0 / minFps)):
		_update_image(s)
	_timer = _timer + delta
