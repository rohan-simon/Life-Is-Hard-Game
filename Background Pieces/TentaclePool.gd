extends Node

export var path : String = ""

var tentacle_pool : Array = []
var tentacle_available : Array = []




#Tentacles should only start appearing when it gets to difficulty level three or higher
#So there must be variable making sure the physics process elements(starting tentacle motion)
#(adding/taking away from list etc) only happens after that difficulty is reached

var right_diff_reached : bool = false

export var initial_pos : Vector2 = Vector2(1100, 600)

var last_spawn_time : int = 0
export var spawn_interval : int = 5000
var time_diff : int = 0

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	right_diff_reached = false
	
	rng.randomize()
	
	var tentacle_paths : Array = get_scenes_in_dir(path)
	
	for path in tentacle_paths:
		#variable stores the data from the scene referenced using the path
		#the data from the scene/file allows us to make an instance of that scene
		#in the form of a Node2D
		
		var scene_data = load(path)
		
		if (path.ends_with("Tentacle.tscn")):
			for i in range(5):
				
				var tentacle : Node2D = scene_data.instance()
				
				tentacle.position = Vector2(1300, 580)
				tentacle_pool.append(tentacle)
				tentacle_available.append(tentacle)
				
				#Adds the Node2D to the root node in the main scene
				add_child_below_node(get_parent(), tentacle)
				
				tentacle.z_index = 13
	
	

		
func _physics_process(delta: float) -> void:
	

	if (right_diff_reached):
		for tentacle in tentacle_pool:
		
			if (tentacle.position.x < -30):
				reset(tentacle)
			
		time_diff = OS.get_system_time_msecs() - last_spawn_time
	
		if (time_diff > spawn_interval):
		
			var available_tentacle : Node2D = find_remove_available_tentacle()
		
			if (available_tentacle == null):
				pass
			else:
			
				available_tentacle.start_moving()
			
				last_spawn_time = OS.get_system_time_msecs()
			
				spawn_interval = rng.randi_range(2000, 5000)

#Given a directory, returns all the scene files in that directory

func get_scenes_in_dir(path : String) -> Array:
	var scenes : Array = []
	var dir : Directory = Directory.new()
	
	if dir.open(path) == OK:
		
		#boolean parameters of list_dir_begin make sure that get_next() does
		#not look at hidden files or navigational files
		
		dir.list_dir_begin(true, true)
		
		var file_name = dir.get_next()
		
		while (file_name != ""):
			if (file_name.ends_with("Tentacle.tscn")):
				
				scenes.append(path + file_name)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
	else:
		print("The directory could not be accessed. Check the path entered.")
			
	return scenes

func reset(tentacle : Node2D) -> void:
	tentacle.position = Vector2(1300, 580)
	tentacle.stop_moving()
	tentacle_available.append(tentacle)

func find_remove_available_tentacle() -> Node2D:
	
	if (tentacle_available.size() == 0):
		return null
	
	var index : int = rng.randi_range(0, tentacle_available.size() - 1)
	var curr_tentacle : Node2D = tentacle_available[index]
	
	tentacle_available.remove(index)
	
	return curr_tentacle
	





func _on_Root_difficulty_2() -> void:
	right_diff_reached = true
