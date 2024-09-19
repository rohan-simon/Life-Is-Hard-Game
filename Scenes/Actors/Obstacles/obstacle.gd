extends KinematicBody2D



var vel : int = 0
var animate : AnimationPlayer = null
export var type : String = ""

var starting_vel : int = 100

#Trying out velocity vector
var vel_vector : Vector2 = Vector2(0,0)

#To make sure it isn't glowing
onready var sprite : Sprite = $Sprite


func _ready():
	
	
	
	
	
	if (type == "bag"):
		animate = $BagAnimationPlayer
	elif (type == "bottle"):
		animate = $BottleAnimationPlayer
	elif (type == "beer_packet"):
		animate = $BeerAnimationPlayer
		


	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	
	#position.x -= vel
	#position.y += vel
	
	vel_vector = Vector2(-vel, vel)
	
	move_and_slide(vel_vector)



func start_moving(delta):
	
	vel = starting_vel
	
	if (type == "bag"):
		animate.play("obstacle_move")
	elif (type == "bottle"):
		animate.play("rotate_bottle")
	elif (type == "beer_packet"):
		animate.play("beer_move")
	
	

func stop_moving():
	
	vel = 0

func return_type() -> String:
	return type
