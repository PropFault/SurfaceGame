@tool
extends AnimationTree

@export var is_punching : bool :
	set(value):
		self.set("parameters/Arms/conditions/is_punching", value)
	get:
		return self.get("parameters/Arms/conditions/is_punching") or false
@export var is_punch_ready : bool :
	set(value):
		self.set("parameters/Arms/conditions/is_punch_ready", value)
	get:
		return self.get("parameters/Arms/conditions/is_punch_ready") or false
@export var walk_in : Vector2 : 
	set(value):
		self.set("parameters/Legs/Walk/blend_position", value)
	get:
		return self.get("parameters/Legs/Walk/blend_position")

enum Wep{
	HAND,
	PISTOL,
	RIFLE
}

@export var wep : Wep : 
	set(value):
		print("Set to ", value)
		self.set("parameters/Arms/conditions/wep_is_pistol", false)
		self.set("parameters/Arms/conditions/wep_is_rifle", false)
		print("Cur: ", wep)
		if(value == Wep.PISTOL):
			print("RES: Wep.PISTOL")
			self.set("parameters/Arms/conditions/wep_is_pistol", true)
		elif(value == Wep.RIFLE):
			self.set("parameters/Arms/conditions/wep_is_rifle", true)
	get:
		var is_pistol = self.get("parameters/Arms/conditions/wep_is_pistol")
		var is_rifle = self.get("parameters/Arms/conditions/wep_is_rifle")
		if(is_pistol):
			return Wep.PISTOL
		elif(is_rifle):
			return Wep.RIFLE
		return Wep.HAND

@export var fire : bool :
	set(value):
		self.set("parameters/Arms/wep_pistol/conditions/fire", value)
		self.set("parameters/Arms/wep_rifle/conditions/fire", value)
	get:
		return self.get("parameters/Arms/wep_pistol/conditions/fire")

@export var reload : bool :
	set(value):
		self.set("parameters/Arms/wep_pistol/conditions/reload", value)
		self.set("parameters/Arms/wep_rifle/conditions/reload", value)
	get:
		return self.get("parameters/Arms/wep_pistol/conditions/reload")


func fire_done():
	fire = false
	return true

func reload_done():
	reload = false
	return true
