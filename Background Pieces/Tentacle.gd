extends KinematicBody2D


onready var animate : AnimationPlayer = $AnimationPlayer

var start : bool = false

var move : float = 0.0



#the tentacle need to osciallte up and down --> with original position being the highest it gets
var original_pos : float = 0.0
var displacement : float = 0.0
var dir : String = ""

var max_disp : float = 0.0

onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	
	rng.randomize()
	
	max_disp  = 60.0
	
	start = false
	
	original_pos = position.y
	
	dir = "down"
	
	
func _physics_process(delta: float) -> void:
	
	displacement = position.y - original_pos
	
	
	
	if (dir == "down"):
		
		if (displacement <= max_disp):
			position.y += 0.5
		else:
			dir = "up"
			original_pos = position.y
		
	if (dir == "up"):
		
		if (displacement >= -max_disp):
			position.y -= 0.5
		else:
			dir = "down"
			original_pos = position.y
		
	
	if (start):
		
		
		#The amount each tentacle is displaced is random
		
		max_disp = rng.randi_range(60, 90)
		
		move = get_parent().get_parent().get_node("Background1").vel
		
		position.x -= move

func start_moving():
	
	start = true
	
	animate.play("tentacle_move")
	
func stop_moving():
	
	start = false
	
