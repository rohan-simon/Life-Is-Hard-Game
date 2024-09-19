extends Node





export var path : String = ""
export var num_of_copies : int = 3
var obstacle_pool : Array = []
var obstacle_available : Array = []

#Seaweed have to stop moving/slow down when the player is dead
var player_dead : bool = false


export var initial_pos : Vector2 = Vector2(1100, 600)

var last_spawn_time : int = 0
export var spawn_interval : int = 5000


var rng : RandomNumberGenerator = RandomNumberGenerator.new()




func _ready() -> void:
	
	rng.randomize()
	
	var obstacle_paths : Array = get_scenes_in_dir(path)
	

	
	
	for path in obstacle_paths:
		#variable stores the data from the scene referenced using the path
		#the data from the scene/file allows us to make an instance of that scene
		#in the form of a Node2D
		var scene_data = load(path)
		
		if (path.ends_with("many_seaweed.tscn")):
			for i in range(num_of_copies):
				var obstacle : Node2D = scene_data.instance()
				
				obstacle.position = Vector2(1300, 580)
				obstacle_pool.append(obstacle)
				obstacle_available.append(obstacle)
				
				#Adds the Node2D to the root node in the main scene
				add_child_below_node(get_parent(), obstacle)
				
				
				
				
				
				
		elif (path.ends_with("many_seaweed_2.tscn")):
			for i in range(num_of_copies + 1):
				var obstacle : Node2D = scene_data.instance()
				obstacle.position = Vector2(1310, 580)
				obstacle_pool.append(obstacle)
				obstacle_available.append(obstacle)
				
				#Adds the Node2D to the root node in the main scene
				add_child_below_node(get_parent(), obstacle)
				
				
				obstacle.z_index = 6
				
				
	

	
	



func _physics_process(delta: float) -> void:
	
	#So after the player dies. After all the obstacles fall out 
	#As the obstacles that have already started moving will
	#continue until they reset
	
	
	if (not player_dead):
	
	
	
		for obs in obstacle_pool:
			if obs.position.x < -30:
				reset(obs)
			
		
	

		var time_diff = OS.get_system_time_msecs() - last_spawn_time
		
		
		
		#Spawn interval should be random --> random spacinf between seaweed
		
		
		
		
		
		
		
		
		if (time_diff > spawn_interval):
	
			var available_obs : Node2D = find_remove_available_obstacle()
	
			if (available_obs == null):
				#print("obstacle_available is empty now")
				pass
			else:
			
				
				
				available_obs.start_moving(delta)
			
				last_spawn_time = OS.get_system_time_msecs()
				
				spawn_interval = rng.randi_range(100, 2000)
					
					
	
	


func find_remove_available_obstacle() -> Node2D:
	
	if (obstacle_available.size() == 0):
		return null
	
	var index : int = rng.randi_range(0, obstacle_available.size() - 1)
	var curr_obstacle : Node2D = obstacle_available[index]
	
	
	
	obstacle_available.remove(index)
	return curr_obstacle



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
	

	
func reset(obs : Node2D) -> void:
	obs.position = Vector2(1300, 580)
	obs.stop_moving()
	obstacle_available.append(obs)



func _on_EndTimer_timeout() -> void:
	player_dead = true


func _on_PlayerStats_player_dead() -> void:
	player_dead = true
