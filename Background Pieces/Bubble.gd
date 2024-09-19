extends StaticBody2D

#For some reason each of the new instances will be under the respective Pool Nodes
#So the Pool Node is the parent. The root node is the parent of the parent(the Pool Node)

onready var animation_player : AnimationPlayer = $BubbleAnimationPlayer

onready var state_machine : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

onready var anim_bubble : AnimationPlayer = $BubbleAnimationPlayer

onready var bubble_sprite : Sprite = $Sprite



var init_time : int = OS.get_system_time_msecs()
var curr_time : int = 0
var time_diff : int = 0
var bubble_duration : int = 0


var original_pos : int  = 0
var displacement : int = 0
var dir : String = ""


var moving : bool = false

#Speed of how the bubble oscillates 
#Should also be dependent on background speed b/c moving with background
var bubble_x_speed : int = 0

func _ready() -> void:
	
	moving = false
	
	set_bubble_duration()

	
	#Used to shift horizontally back and forth
	original_pos = position.x
	#bubbles always start going left then continously switch directions
	dir = "left"

func _physics_process(delta: float) -> void:
	

	
	
	
	
	
	
	#considering bubble animations + bubble going up
	
	if (moving):
		
		#bubble horizontal speed should change
		#with the background speed
		
		bubble_x_speed = 1 
		
		curr_time = OS.get_system_time_msecs()
	
		time_diff = curr_time - init_time

	
		if (time_diff < bubble_duration):
			state_machine.travel("bubble_still")
		
			#Only do oscillating movement when still --> not when bubble bursts
			#Shifting horizontally back and forth
			displacement = position.x - original_pos
	
			if (dir == "left" && displacement >= -5):
				position.x -= bubble_x_speed 
				

				
			elif (displacement < -5):
				dir = "right"
				#original position value is changed so that displacement is reset
				#to be used when moving the opposite direction
				original_pos = position.x
	
			if (dir == "right" && displacement <= 5):
				position.x += bubble_x_speed
				

				#
			elif (displacement > 5):
				dir = "left"
				#original position value is changed so that displacement is reset
				#to be used when moving the opposite direction
				original_pos = position.x
		
		
	
		elif (time_diff > bubble_duration and time_diff < 5000):
		
			state_machine.travel("bubble_disappear")
	
	
		position.y -= 100 * delta


	
func set_bubble_duration(time = 2000):
	bubble_duration = time
	
	
#Fill in -> must deal with movement + animation + visibility
#Bubble must be invisible when reset + stop moving etc.
func reset():
	moving = false
	visible = false
	
func start_moving():
	moving = true
	visible = true
	init_time = OS.get_system_time_msecs()
	
