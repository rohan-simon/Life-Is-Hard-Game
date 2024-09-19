extends Node

#In this code
#Once an obstacle starts moving it doesn't stop moving
#b/c obstacle vel is not reset to 0
#position is reset and the object continues to move
#It's fine tho --> there may be some redundancy in code however


export var path : String = ""
export var num_of_copies : int = 3
var obstacle_pool : Array = []
var obstacle_available : Array = []

var min_x : int = 1200
var max_x : int = 400

var last_spawn_time : int = 0
export var spawn_interval : int = 2000


var rng : RandomNumberGenerator = RandomNumberGenerator.new()

#Objects must move out of screen and no new objects must enter screen
#set to true either when player is dead or when game has ended
var player_dead : bool = false


#Used to change difficulties
var diff_1 : bool = false
var diff_2 : bool = false
var diff_3 : bool = false
var diff_4 : bool = false


func _ready() -> void:
	
	rng.randomize()
	
	var obstacle_paths : Array = get_scenes_in_dir(path)
	
	
	for path in obstacle_paths:
		#variable stores the data from the scene referenced using the path
		#the data from the scene/file allows us to make an instance of that scene
		#in the form of a Node2D
		var scene_data = load(path)
		
		if (path.ends_with("PlasticBag.tscn")):
			for i in range(num_of_copies):
				var obstacle : Node2D = scene_data.instance()
				
				obstacle.position = get_start_pos()
				obstacle_pool.append(obstacle)
				obstacle_available.append(obstacle)
				
				#Adds the Node2D to the root node in the main scene
				add_child_below_node(get_parent(), obstacle)
				
				obstacle.z_index = 5
				
				
				
				
				
				
		elif (path.ends_with("PlasticBottle.tscn")):
			for i in range(num_of_copies + 10):
				var obstacle : Node2D = scene_data.instance()
				obstacle.position = get_start_pos()
				obstacle_pool.append(obstacle)
				obstacle_available.append(obstacle)
				
				#Adds the Node2D to the root node in the main scene 
				#--> use get_parent() as first parameter
				
				#For now adds Node2D under the ObjectPool scene
				#--> uses self as the first parameter
				add_child_below_node(self, obstacle)
				
		elif (path.ends_with("BeerPacket.tscn")):
			for i in range(3):
				var obstacle : Node2D = scene_data.instance()
				obstacle.position = get_start_pos()
				obstacle_pool.append(obstacle)
				obstacle_available.append(obstacle)
				
				#Adds the Node2D to the root node in the main scene 
				#--> use get_parent() as first parameter
				
				#For now adds Node2D under the ObjectPool scene
				#--> uses self as the first parameter
				add_child_below_node(self, obstacle)
				
				
				
	
	



func _physics_process(delta: float) -> void:
	
	#So after the player dies. After all the obstacles fall out 
	#As the obstacles that have already started moving will
	#continue until they reset
	
	
	
	
	for obs in obstacle_pool:
		if obs.position.x < -100 or obs.position.y > 670:
			reset(obs)
			
		
	if (not player_dead):
		var time_diff = OS.get_system_time_msecs() - last_spawn_time
	
		if (time_diff > spawn_interval):
	
			var available_obs : Node2D = find_remove_available_obstacle()
	
			if (available_obs == null):
				#print("obstacle_available is empty now")
				pass
			else:
			
				
				if (diff_1):
					#normal was 90
					available_obs.starting_vel = 140
				elif (diff_2):
					available_obs.starting_vel = 170
				elif (diff_3):
					available_obs.starting_vel = 190
				elif (diff_4):
					available_obs.starting_vel = 190
			
				available_obs.start_moving(delta)
			
				last_spawn_time = OS.get_system_time_msecs()
	
	


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
	
	
func get_start_pos() -> Vector2:

	var x : int = rng.randi_range(min_x, max_x)
	
	var min_y = 0
	var max_y = 0
	
	if (x < 1050):
		min_y = -300
		max_y = -150
		
		
	else:
		min_y = -150
		max_y = 400
		
		
	
		
	var y : int = rng.randi_range(min_y, max_y)
	
	
	return Vector2(x, y)
	
func reset(obs : Node2D) -> void:
	obs.position = get_start_pos()
	obs.stop_moving()
	obstacle_available.append(obs)


func _on_PlayerStats_player_dead() -> void:
	player_dead = true


func _on_EndTimer_timeout() -> void:
	#Game has ended, so obstacles should slowly get off screen
	player_dead = true


func _on_Root_difficulty_1() -> void:
	
	diff_1 = true
	spawn_interval = 700


func _on_Root_difficulty_2() -> void:
	
	diff_2 = true
	
	diff_1 = false
	
	spawn_interval = 500


func _on_Root_difficulty_3() -> void:
	
	diff_3 = true
	
	diff_2 = false
	
	#Shoule be 400
	
	spawn_interval = 400


func _on_Root_difficulty_4() -> void:
	
	diff_4 = true
	
	diff_3 = false
	
	#Should be 300
	
	spawn_interval = 300
