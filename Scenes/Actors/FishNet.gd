extends KinematicBody2D



#represents when the net should go up after the game ends
var start_going_up : bool = false

var player : Node = null



var down_vel : Vector2 = Vector2(0,0)
var up_vel : Vector2 = Vector2(0, 0)

export var anim_speed : float = 1.5

#gets root node of the Animation Tree of the FishNet
onready var state_machine : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")

onready var timer = $Timer


#keeps track of the direction the fish_net was last traveling in
#0 means that the fishnet was still
#-1 means that the fishnet was traveling up before that point
#1 means that the fishnet was traveling down before that point
var latest_dir : int = 0

#0 means still, -1 means up, 1 means down
var curr_dir : int = 0

func _ready() -> void:
	
	#gets player node
	player = get_node("../Player")
	
	#Speed of net dependent on player's max speed
	
	
	down_vel = Vector2(0, player.max_speed.y/90)
	
	up_vel = Vector2(0, -player.max_speed.y/90)


func _physics_process(delta: float) -> void:
	
	var curr_state = state_machine.get_current_node()
	
	#Follows the horizontal position of the fish, follows at slower rate than fish
	#follows until around area of the fish +/-5 pixels of fish center
	
	
	if (not start_going_up):
	
		if (position.y < player.position.y - 10):
		
		
			move_and_slide(down_vel)
		
		
		
		
		
			latest_dir = 1
			state_machine.travel("down")
		
		
		elif (position.y > player.position.y + 10):
		
			move_and_slide(up_vel)
		
		
		
			latest_dir = -1
			state_machine.travel("up")
		
		
		else:
		
		
			if (curr_state != "still"):
				state_machine.travel("still")
		
		
		
			#may be unnecessary. if state already at still then traveling
			#to still may not make any changes
			latest_dir = 0
	
	else:
		#If the game has ended
		
		#If statement to make sure that the 
		#net doesn't keep moving forever
		
		if (position.y > -1000):
			move_and_slide(up_vel)
			state_machine.travel("up")
			
		
		
	
	
	


func _on_EndTimer_timeout() -> void:
	timer.start(4)


func _on_Timer_timeout() -> void:
	start_going_up = true
