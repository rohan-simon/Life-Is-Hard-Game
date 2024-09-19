extends Node

export var path : String = ""
var bubble_pool : Array = []
var bubble_available : Array = []


var time_diff : int = 0
var last_spawn_time : int = 0
export var spawn_interval : int = 200

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	
	last_spawn_time = 0
	
	rng.randomize()
	
	var bubble_paths : Array = get_scenes_in_dir(path)
	
	for path in bubble_paths:
		
		#variable stores the data from the scene referenced using the path
		#the data from the scene/file allows us to make an instance of that scene in the form of 
		#a Node2D
		var scene_data = load(path)
		
		if (path.ends_with("Bubble.tscn")):
			
			for i in range(20):
				var bubble : Node2D = scene_data.instance()
				
				
				
				bubble.position = get_pos()
				bubble_pool.append(bubble)
				bubble_available.append(bubble)
				bubble.visible = false
			
				#Adds the Node2D to the root node in the main scene
			
				add_child_below_node(get_parent(), bubble)
				
				bubble.z_index = 8
		

		
func _physics_process(delta : float) -> void:
	
	for bubble in bubble_pool:
		if (bubble.position.y < -75):
			reset(bubble)
	
	time_diff = OS.get_system_time_msecs() - last_spawn_time
	
	if (time_diff > spawn_interval):
		
		var available_bubble : Node2D = find_remove_available_bubble()
		
		if (available_bubble == null):
			pass
		else:
			
			available_bubble.start_moving()
			
			last_spawn_time = OS.get_system_time_msecs()
			


func get_scenes_in_dir(path : String) -> Array:
	var scenes : Array = []
	var dir : Directory = Directory.new()
	
	if dir.open(path) == OK:
		#boolean parameters of list_dir_begin make sure that get_next() does
		#not look at hidden or navigational files
		
		dir.list_dir_begin(true, true)
		
		var file_name = dir.get_next()
		
		while (file_name != ""):
			
			if (file_name.ends_with("Bubble.tscn")):
				scenes.append(path + file_name)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
	else:
			
		print("The directory could not be accessed. The path may be entered wrong,")
			
			
	return scenes
	

func reset(bubble : Node2D) -> void:
	
	
	bubble.position = get_pos()
	
	#random value for when bubble pops --> in milliseconds
	var bubble_duration = rng.randi_range(300, 3000)
	bubble.set_bubble_duration(bubble_duration)
	
	#bubble stops animating etc.
	bubble.reset()
	bubble_available.append(bubble)
	
func find_remove_available_bubble() -> Node2D:
	
	if (bubble_available.size() == 0):
		return null
		
	var index : int = rng.randi_range(0, bubble_available.size() - 1)
	var curr_bubble : Node2D = bubble_available[index]
	
	bubble_available.remove(index)
	
	return curr_bubble
	
func get_pos() -> Vector2:
	
	var x : int = rng.randi_range(-3, 1003)
	var y : int = rng.randi_range(100, 600)
	
	return Vector2(x, y)
	
