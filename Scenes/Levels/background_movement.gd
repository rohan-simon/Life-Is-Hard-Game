extends Sprite



export var vel : float = 12
var sprite_width : float = 0

#Background must stop moving if the player is dead
var player_dead : bool = false

#Background must slow down and then stop moving if the
#game ends

var game_ended : bool = false

#Game end variables, so that background slows down gradually
var last_slow_down : int = 0
var time_diff : int = 0
var time_interval : int = 100


func _ready() -> void:

	#Game should slowly speed up
	vel = 0
	
	
	#get's width of the background image, used for displacement
	sprite_width = texture.get_size().x * scale.x
	
	
func _physics_process(delta: float) -> void:

	

	#Gradually slows down the background when game ends
	if (game_ended):
		
		vel -= 0.1
		
		
		if (vel < 0):
			vel = 0
		
		
		position.x -= vel
		
		
		
		#time_diff = OS.get_system_time_msecs() - last_slow_down
		
		#if (time_diff > time_interval):
		
		#	vel -= 0.1
		#	if (vel < 0):
		#		vel = 0
		#	last_slow_down = OS.get_system_time_msecs()

	#So the background will only move when the player is alive --> when the player is dead it will stop, but vel 
	#will not change
	if (not player_dead && not game_ended):
		
		vel += 0.05
		
		#original max vel is 12
		if (vel > 12):
			vel = 12

		position.x -= vel
	
	
	
	
	#If the player is dead you want to set the vel to 0 --> so that it can
	#be used by the seaweed + others
	
	if (player_dead):
		vel = 0
	
	#continue to reposition as necessary even when game has ended etc.
	_reposition()

#when the background image is fully out of the window, it goes to
#end of the other background image to make the whole scene loop
func _reposition():
	if (position.x < -sprite_width):
		position.x += 2 * sprite_width
		


func _on_PlayerStats_player_dead() -> void:
	player_dead = true


func _on_EndTimer_timeout() -> void:
	game_ended = true
