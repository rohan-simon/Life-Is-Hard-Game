extends KinematicBody2D

#Used to give the diff. glow values for the diff angler fish
export var type : String = ""

#Speed Values for move_and_slide()
var max_h_speed : int = -350

#min_h_speed is supposed to be -50
var min_h_speed : int = -50

var h_speed = 0




var original_speed : Vector2 = Vector2.ZERO
var follow_speed : Vector2 = Vector2.ZERO

var curr_speed : Vector2 = Vector2.ZERO

var final_speed : Vector2 = Vector2.ZERO


onready var animate : AnimationPlayer = $AnimationPlayer




var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var rand_val = 0
var anim_speed_scale : float = 0.0


#To get player info. when it needs to chase player
onready var player_detection_zone : Area2D = $PlayerDetection

onready var tween : Tween = $Tween


#The angler fish always needs to know when the game has ended --> AnglerPool will directly
#tell all the fishes in the pool when the game has ended

var game_ended : bool = false






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	game_ended = false
	
	rng.randomize()
	
	h_speed = 0

	

func _physics_process(delta: float) -> void:

		
		
		
	#To get access to player position
	
	var player = player_detection_zone.player
	
	#If player is in zone then go towards player
	
	if (player_detection_zone.can_see_player() && player.get_global_position().x + 10 	< position.x):
		
		follow_speed = position.direction_to(player.get_global_position())
		
		
		
		#The 90 can be changed to a random number
		
		#each angler fish starts moving at different speeds when it sees the fish etc.
		follow_speed = follow_speed.normalized() * (original_speed.x * -1)
		
		curr_speed = curr_speed.move_toward(follow_speed, delta * 200)
		
		
		
		final_speed = curr_speed
		
	
	else:
		
		curr_speed = curr_speed.move_toward(original_speed, delta * 100)
		
		final_speed = curr_speed
	
	
	#When the game's ended you want the angler fish to increase speed
	#and only move horizontally --> increase speed based on initial speed
	
	if (game_ended):
		
		
		#Thing of making it faster --> ask Sidd what he thinks
		#Make it faster or keep it same speed???
		curr_speed = curr_speed.move_toward(original_speed, delta * 400)
		
		final_speed = curr_speed
	
	
	animate.play("swim")
	animate.set_speed_scale(anim_speed_scale)
	
	
	
	move_and_slide(final_speed)
	#position.x -= move

func start_moving():
	
	h_speed = rng.randi_range(min_h_speed, max_h_speed)
	
	original_speed = Vector2(h_speed, 0)
	
	curr_speed = original_speed
	
	#The float must be between 0.7 and 1.7 in 0.1 increments --> so 
	#first uses random number between 7 and 17 to then use the tenth
	#Divide by float to get a float
	rand_val = rng.randi_range(5, 17) / 10.0
	
	anim_speed_scale = rand_val
	

func stop_moving():
	h_speed = 0
	
func tell_game_ended():
	
	game_ended = true


