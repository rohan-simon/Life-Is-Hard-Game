extends Node


export var path : String = ""

var fish_pool : Array  = []
var fish_available : Array = []

var last_spawn_time : int = 0
export var spawn_interval : int = 6000
var time_diff : int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var game_ended : bool = false

func _ready() -> void:
	
	game_ended = false
	
	rng.randomize()
	
	var obstacle_paths : Array = get_scenes_in_dir(path)
	
	for path in obstacle_paths:
		#variable stores the data from the scene referenced using the path
		#the data from the scene/file allows us to make an instance of that scene
		#in the form of a Node2D
		
		var scene_data = load(path)
		
		if (path.ends_with("FishYellow.tscn") or path.ends_with("FishBlue.tscn")):
			
			for i in range(4):
				
				var fish : Node2D = scene_data.instance()
				
				fish.position = get_pos()
				fish_pool.append(fish)
				fish_available.append(fish)
				
				#Adds the Node2D under the FishPool node
				
				add_child_below_node(self, fish)
				
		elif (path.ends_with("FishPink.tscn")):
			
			for i in range(3):
				var fish : Node2D = scene_data.instance()
				
				fish.position = get_pos()
				fish_pool.append(fish)
				fish_available.append(fish)
				
				#Adds the Node2D under the FishPool node
				
				add_child_below_node(self, fish)
				
				fish.z_index = 4
				
				
				

func _physics_process(delta: float) -> void:
	
	for fish in fish_pool:
		
		if fish.position.x < -30 or fish.position.x > 1500:
			reset(fish)
		
	
	if (not game_ended):
	
		time_diff = OS.get_system_time_msecs() - last_spawn_time
	
		#Spawn interval should be random 
	
		if (time_diff > spawn_interval):
		
			var available_fish : Node2D = find_remove_available_fish()
		
			if (available_fish == null):
				pass
			else:
			
				available_fish.start_moving()
				last_spawn_time = OS.get_system_time_msecs()
			
				spawn_interval = rng.randi_range(2000, 6000)

#Given a directory, returns all the scene files in that directory -->
#Used to make the object pool
func get_scenes_in_dir(path : String) -> Array:
	var scenes : Array = []
	var dir : Directory = Directory.new()
	
	if dir.open(path) == OK:
		
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
	
	
func get_pos() -> Vector2:
	
	var x : int = 1300
	var y : int = rng.randi_range(25, 500)
	
	return Vector2(x, y)

func reset(fish : Node2D) -> void:
	fish.position = get_pos()
	fish.reset()
	fish_available.append(fish)
	
func find_remove_available_fish() -> Node2D:
	
	if (fish_available.size() == 0):
		return null
	
	var index : int = rng.randi_range(0, fish_available.size() - 1)
	var curr_fish : Node2D = fish_available[index]
	
	fish_available.remove(index)

	return curr_fish
	
	
	
	


func _on_PlayerStats_player_dead() -> void:
	game_ended = true


func _on_EndTimer_timeout() -> void:
	game_ended = true
