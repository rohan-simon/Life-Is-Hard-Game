extends StaticBody2D

#For some reason each of the new instances will be under the respective Pool Nodes
#So the Pool Node is the parent. The root node is the parent of the parent(the Pool Node)

var moving : bool = false

onready var animate : AnimationPlayer = $FishAnimationPlayer

var displace : float = 0.0
var background_vel : float = 0.0
#Ever time one of the fishes starts moving it should have a random speed
var rng : RandomNumberGenerator = RandomNumberGenerator.new()


#no more need to spawn fishes after game has ended


func _ready() -> void:
	
	
	
	rng.randomize()
	
	moving = false
	
	
func _physics_process(delta: float) -> void:
	
	if (moving):
		
		
		#if the background speed suddenly changes to be less than the fish speed
		#change the fish speed accordingly
		background_vel = get_parent().get_parent().get_node("Background1").vel
		
		if (background_vel < displace):
			
			position.x -= background_vel - displace
			
		else:
			
			position.x -= displace
		
	

func start_moving():
	
	moving = true
	
	animate.play("fish_swim")
	
	background_vel = get_parent().get_parent().get_node("Background1").vel
	
	#lower limit for fish speed should be a tenth of the background speed
	#upper limit for fish speed should be half of the background speed
	#fish should never have a speed greater than the background
	displace = rng.randf_range(background_vel / 10, background_vel / 2)
	
	
	

func reset():
	
	moving = false
