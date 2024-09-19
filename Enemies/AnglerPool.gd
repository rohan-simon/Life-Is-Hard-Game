extends Node


export var path : String = ""

var angler_pool : Array = []
var angler_available : Array = []

var last_spawn_time : int = 0

#Spawn interval should be 20000
export var spawn_interval : int = 13000

var time_diff : int = 0

var rng : RandomNumberGenerator = RandomNumberGenerator.new()


#The angler fish will be released after a while

var release: bool = false


#Angler fish need to stop spawning when player is dead or game is over
var game_ended : bool = false


func _ready() -> void:
	
	
	game_ended = false
	
	release = false
	
	
	rng.randomize()
	last_spawn_time = 0
	
	var angler_paths : Array = get_scenes_in_dir(path)
	
	for path in angler_paths:
		
		#if (path.ends_with("Angler_Red.tscn")):
			
		#	var scene_data = load(path)
			
		#	for i in range(5):
				
		#		var angler : Node2D = scene_data.instance()
				
		#		angler.position = get_start_pos()
		#		angler_pool.append(angler)
		#		angler_available.append(angler)
				
				#Adds the Node2D under this node
				
		#		add_child_below_node(self, angler)
		
		#For now make them all red
		
		if (path.ends_with("Angler_Purple.tscn")):
			var scene_data = load(path)
			
			#Normal is 7
			for i in range(12):
				
				var angler : Node2D = scene_data.instance()
				
				angler.position = get_start_pos()
				angler_pool.append(angler)
				angler_available.append(angler)
				
				#Adds the Node2D under this node
				
				add_child_below_node(self, angler)
				
				angler.z_index = 13
			
	


func _physics_process(delta: float) -> void:
	
	
	
	
	
	for angler in angler_pool:
		
	
		
		if (angler.position.x > 1200 or angler.position.y > 700):
			reset(angler)
		
		if (!game_ended and release):
		
			time_diff = OS.get_system_time_msecs() - last_spawn_time
		
			if (time_diff > spawn_interval):
				var available_angler : Node2D = find_remove_available_angler()
			
				if (available_angler == null):
					
					last_spawn_time = OS.get_system_time_msecs()
				else:
				
					available_angler.start_moving()
					last_spawn_time = OS.get_system_time_msecs()
		
		elif (game_ended):
			
			angler.tell_game_ended()
			
			
		
		


func find_remove_available_angler() -> Node2D:
	if (angler_available.size() == 0):
		return null
		
	var index : int = rng.randi_range(0, angler_available.size() - 1)
	var curr_angler : Node2D = angler_available[index]
	
	angler_available.remove(index)
	
	return curr_angler

#Given a directory, returns all the scene files in that directory -->
#Used to make the object pool

func get_scenes_in_dir(path : String) -> Array:
	
	var scenes : Array = []
	var dir : Directory = Directory.new()
	
	if (dir.open(path) == OK):
		
		#boolean parameters of list_dir_begin make sure that get_next() does
		#not look at hidden files or navigational files
		
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		
		while (file_name != ""):
			
			if (file_name.ends_with(".tscn")):
				scenes.append(path + file_name)
			
			file_name = dir.get_next()
			
		dir.list_dir_end()
		
	else:
		
		print("The directory could not be accessed. The path may be entered wrong.")
	
	return scenes
	
func get_start_pos() -> Vector2:
	
	var y = rng.randi_range(0, 500)
	
	
	
	return Vector2(1200, y)
	
func reset(angler : Node2D) -> void:
	
	angler.position = get_start_pos()
	angler.stop_moving()
	angler_available.append(angler)



func _on_EndTimer_timeout() -> void:
	game_ended = true


func _on_PlayerStats_player_dead() -> void:
	game_ended = true


func _on_MainScene_difficulty_2() -> void:
	
		
		release = true
		
		


func _on_MainScene_difficulty_3() -> void:

	if (angler_pool.size() < 23):
		
		var angler_paths : Array = get_scenes_in_dir(path)
		
		for path in angler_paths:
	
			if (path.ends_with("Angler_Red.tscn")):
			
				var scene_data = load(path)
			
				for i in range(5):
				
					var angler : Node2D = scene_data.instance()
				
					angler.position = get_start_pos()
					angler_pool.append(angler)
					angler_available.append(angler)
					
					angler.z_index = 17
					
				
					#Adds the Node2D under this node
				
					add_child_below_node(self, angler)
