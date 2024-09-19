extends StaticBody2D



#For some reason each of the new instances will be under the respective Pool Nodes
#So the Pool Node is the parent. The root node is the parent of the parent(the Pool Node)

var move : float = 0.0

var animate : AnimationPlayer = null

var start : bool = false

func _ready() -> void:
	animate = $AnimationPlayer
	
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	
	
	#get_parent() goes up one node
	#so get_parent().get_parent() goes to the root node of the scene
	#from that root node we can go to background1 directly
	
	#if (move != 12):
	
	
	if (start):
		
		
		move = get_parent().get_parent().get_node("Background1").vel
	
		position.x -= move

	

	
# warning-ignore:unused_argument
func start_moving(delta):
	
	
	
	
	start = true
	
	animate.play("wave")
	
func stop_moving():
	
	
	start = false
