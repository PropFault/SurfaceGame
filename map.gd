extends TileMap
@export var player_spawn : Node2D
@export var entrance: PackedScene
@export var exit : PackedScene
@export var door : PackedScene
@export var terrainSet: int
@export var terrainFloor: int
@export var terrainCorridor: int
@export var door_spawn_node : Node2D
@export var reload: bool: 
	get: 
		return true 
	set(value): 
		_ready()
func _gen(pos: Vector2i, cur_dir: Vector2i, bounds: Vector2i, data: Dictionary):
	var r = _try_move(pos, cur_dir, bounds, data)
	pos = r.pos
	cur_dir = r.cur_dir
	if r.success:
		_gen(pos, cur_dir, bounds, r.data)
	else:
		var respawn = randf_range(0.0, 1.0)
		if(respawn > 0.1):
			var i = randi_range(0, r.data.size()-1)
			_gen(r.data.keys()[i], Vector2i(-cur_dir.y, cur_dir.x), bounds, r.data)
	return r.data
	
func _try_move(pos: Vector2i, cur_dir: Vector2i, bounds: Vector2i, data: Dictionary):
	var turn = randf_range(0, 1.0)
	var dirs = [cur_dir, Vector2i(-cur_dir.y, cur_dir.x), Vector2i(cur_dir.y, -cur_dir.x)]
	if turn > 0.8:
		if turn > 0.9: # counter clockwise
			cur_dir = dirs[1]
		else: # clockwise
			cur_dir = dirs[2]
	var next_cel = pos + cur_dir
	var is_free = false;
	var tries = 0
	while not is_free:
		next_cel = pos + cur_dir
		is_free = not data.has(next_cel) and (bounds.x / 2) > abs(next_cel.x) and (bounds.y / 2) > abs(next_cel.y)
		cur_dir = dirs[tries]
		tries = tries + 1
		if tries > 2:
			break;
	
	if is_free:
		print("SETTING: ", next_cel)
		data[next_cel] = null
		var l = next_cel + Vector2i(-cur_dir.y, cur_dir.x);
		var r = next_cel + Vector2i(-cur_dir.y, cur_dir.x);
		if(not data.has(l)):
			data[l] = null
		else:
			data[r] = null
	
		

	
	return {
		pos = next_cel,
		cur_dir = cur_dir,
		success = is_free,
		data = data
	}
		

func _gen_rooms(path_data: Dictionary, room_data: Dictionary):
	var dirs = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1, 0), Vector2i(0, -1)];
	# 1. Walk the path
	for i in range(0, path_data.size()):
		var cursor = path_data.keys()[i]
		# Decide if you would like to generate a room here
		var should_gen = randf_range(0.0, 1.0)
		if should_gen > 0.95:
			# Check if you can generate a room somewhere here
			for d in dirs:
				var entry = cursor + d
				if not path_data.has(entry): # check if free space
					var fail = false
					var innerDirs = []
					for c in dirs:
						if c != (d * -1):
							innerDirs.append(c)
					for di in innerDirs:
						if path_data.has(entry + di): # check if there is enough space for a room
							fail = true
							break
					if not fail: # we can make a room here :)
						room_data = _gen_room(path_data, room_data, entry, d)
	return room_data
func _gen_room(path_data: Dictionary, room_data: Dictionary, entrance: Vector2i, entrance_dir: Vector2i):
	var door_inst = door.instantiate()
	var angle = Vector2(0, 1).angle_to(entrance_dir)
	door_spawn_node.add_child(door_inst)
	door_inst.position = self.map_to_local(entrance) - entrance_dir * 16.0
	door_inst.rotation = angle
	var cursor = entrance
	var dir_l = Vector2i(-entrance_dir.y, entrance_dir.x)
	var dir_r = Vector2i(entrance_dir.y, -entrance_dir.x)
	var target_l = randi_range(3, 16)
	var target_r = randi_range(3, 16)
	var target_d = randi_range(3, 16)
	var d = 0;
	while d < target_d:
		var l = 0
		while l < target_l:
			cursor = cursor + dir_l
			if path_data.has(cursor):
				target_l = l
			else:
				room_data[cursor] = null
			l = l + 1
		var r = 0
		while r < target_r:
			cursor = cursor + dir_r
			if path_data.has(cursor):
				target_r = r
			else:
				room_data[cursor] = null
			r = r + 1
		cursor = entrance + entrance_dir * d
		d = d + 1
		
		var should_expand = randf_range(0.0, 1.0)
		if should_expand > 0.98:
			target_l = randi_range(3, 16)
			target_r = randi_range(3, 16)
	return room_data
func _ready():
	
	if(door_spawn_node == null):
		door_spawn_node =get_node("door_spawn")
	self.clear();
	var path = _gen(Vector2i(0,0), Vector2i(1,0), Vector2i(64, 64), {})
	var rooms = _gen_rooms(path, {})
	self.set_cells_terrain_connect(0, path.keys(), 0, 1, false)
	self.set_cells_terrain_connect(1, rooms.keys(), 0, 0, false)
	
	var background = []
	var rect = self.get_used_rect()
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			background.append(Vector2i(x,y))
	self.set_cells_terrain_connect(2, background, 0, 2, false)
	var cells = []
	for c in door_spawn_node.get_children():
		cells.append(self.local_to_map(c.position))
		self.set_cells_terrain_connect(1, cells, 0, 3, false)
