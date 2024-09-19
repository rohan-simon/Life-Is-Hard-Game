extends KinematicBody2D

#To turn of collision so fish can swim away
signal turn_off_tilemap

#To show the congrats screen
signal end_card

#To do away with health UI when fish swims away 
signal health_disappear

#To show the you died screen
signal death_screen

#fish should die in 3 hits

#velocity with which the sprite moves
var velocity : Vector2 = Vector2.ZERO

#Used to set the knockback value/distance
var knockback_vel : Vector2 = Vector2.ZERO

#sets up the maximum speed, the amount the fish can speed up, the amount
#it can slow down when buttons aren't pressed.
export var max_speed : Vector2 = Vector2(9000, 5000)

export var anim_speed : float = 0.5

var speed_increment : Vector2 = Vector2(max_speed.x/28, max_speed.y/20)
var slow_down : Vector2 = Vector2(max_speed.x/80, max_speed.y/50)
var dir : Vector2 = Vector2.ZERO

#Time counter to slow down fish when dead

var last_anim_speed_change : int = 0
var anim_speed_change_interval : int = 4000
var time_diff : int  = 0

#variable controlling when to switch to fish still frame
var to_dead_fish : bool = false


#Knockback -> everytime hurtbox entered by an obstacle
#Fish should get knocked away -> changes velocity, with velocity
#gradually going to 0





########

#TEST VARIABLE
var counter : int = 1


########




#The velocity should only be changing if the player is not dead
#So variable keeps track if player is dead

#player_dead also represents when the player has completed the game
var player_dead : bool = false

#similar to when player dies, when game ends player should stop
#moving
#but player should continue to animate - so using different variable
var game_ended : bool = false
#after game ends, after 3 seconds fish should move out of screen

#Made an onready b/c must equal 0 before game ends --> used to make sure
#it's value isn't constantly changed
onready var game_end_time : int = 0


var time_diff_swim : int = 0
var swim_away_interval : int = 10000



#In order to flip the sprite image depending on the velocity
onready var sprite : Sprite = get_node("pixel_fish")


#In order to change the glow of the fish when it becomes night

onready var glow_tween : Tween = $GlowTween
var glow_on = Color(1.21, 1.21, 1.21, 1)
var glow_off = Color(1, 1, 1, 1)

var start_glow : bool = false

#Animation player to animate the sprite
onready var animate : AnimationPlayer = $animate_sprite

#In order to change/keep track of Player health
onready var player_stats = $PlayerStats
	

#In order to turn on invincibility etc.
onready var hurtbox = $Hurtbox


#In order to play hit sound everytime
#The hurtbox is entered
onready var music_player : AudioStreamPlayer = $AudioStreamPlayer




#Needed to let the angler fish know when to glow
var glowing : bool = false

func _physics_process(delta: float) -> void:

	if (start_glow):
		
		glowing = true
		
		glow_tween.interpolate_property(sprite, "modulate", sprite.modulate, glow_on, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		glow_tween.start()
	
	else:
		
		glowing = false
		
		glow_tween.interpolate_property(sprite, "modulate", sprite.modulate, glow_off, 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		glow_tween.start()

	
	if (player_dead):
		
		time_diff = OS.get_system_time_msecs() - last_anim_speed_change
		
		if (time_diff > anim_speed_change_interval):
			
			anim_speed -= 0.35
			
			if (anim_speed < 0):
				to_dead_fish = true
				anim_speed = 0
				
				emit_signal("death_screen")
			
			last_anim_speed_change = OS.get_system_time_msecs()
			
	
	if (not to_dead_fish):
		animate.play("normal_move")
		animate.set_speed_scale(anim_speed)
	else:
		animate.play("fish_still")
	
	sprite.flip_h = true
	
	

	
	if (not player_dead && not game_ended):
		
	
	
	
		#Moves to the right when right arrow pressed
		if (Input.is_action_pressed("move_right")):
		
	
		
			velocity.x += speed_increment.x * delta
		
			if (velocity.x > max_speed.x * delta):
				velocity.x = max_speed.x * delta
	
		
		
	
		#Moves to the left when left arrow pressed
		if (Input.is_action_pressed("move_left")):
		
		
			velocity.x -= speed_increment.x * delta
		
			if (velocity.x < -max_speed.x * delta):
				velocity.x = -max_speed.x * delta
	
		
	
		#Moves up when up arrow pressed
		if (Input.is_action_pressed("move_up")):

			velocity.y -= speed_increment.y * delta
		
			if (velocity.y < -max_speed.y * delta):
				velocity.y = -max_speed.y * delta
		
		
		

		
	
		if (Input.is_action_pressed("move_down")):
		
			velocity.y += speed_increment.y * delta
		
			if (velocity.y > max_speed.y * delta):
				velocity.y = max_speed.y * delta
		
		
	
		if (velocity.y > 0):
			dir.y = -1
		elif (velocity.y < 0):
			dir.y = 1
		else:
			dir.y = 0
	
		if (velocity.x > 0):
			dir.x = 1
		elif (velocity.x < 0):
			dir.x = -1
		else:
			dir.x = 0
	
	
	
		_gradual_slow_down(delta)
	
	else:
		
		
		velocity = Vector2.ZERO
		
		
		
		
		if (game_ended):
			
			time_diff_swim = OS.get_system_time_msecs() - game_end_time
			
			
			
			if (time_diff_swim > swim_away_interval):
				
				emit_signal("turn_off_tilemap")
				emit_signal("health_disappear")
				
				
				
				
				if (position.x < 1500):
				
					position.x += 3
				else:
					emit_signal("end_card")
				
			
					
					
			
			
		
	
	
	
	
	velocity = move_and_slide(velocity)
	
	

#Slows down in the direction that it last traveled
func _gradual_slow_down (delta):
	if (!Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right")):
		
		
		
		
		if (dir.x == 1 && velocity.x > 0):
		
			velocity.x -= slow_down.x * delta
			
			
			#Done in case subtracting velocity makes it
			#not zero
			if (velocity.x < 0):
				velocity.x = 0
				
		
		
		if (dir.x == -1 && velocity.x < 0):
			velocity.x += slow_down.x * delta
			
			
			#Done in case subtracting velocity makes it
			#not zero
			if (velocity.x > 0):
				velocity.x = 0
				
				
				
	if (!Input.is_action_pressed("move_up") && !Input.is_action_pressed("move_down")):
		
		
		
		#Added && velocity.y < 0 for testing purposes
		if (dir.y == 1 && velocity.y < 0):
			velocity.y += slow_down.y * delta
			
			
			
			#Done in case subtracting velocity makes it
			#not zero
			if(velocity.y > 0):
				velocity.y = 0
				
		#Added && velocity.y > 0 for testing purposes
		if (dir.y == -1 && velocity.y > 0):
			velocity.y -= slow_down.y * delta
			
			
			#Done in case subtracting velocity makes it
			#not zero
			if (velocity.y < 0):
				velocity.y = 0
	
	
	
	
func _on_Hurtbox_area_entered(area: Area2D) -> void:
	

	
	if (not game_ended and not player_dead):
	
		player_stats.health -= 1
		
		music_player.play()
	
		hurtbox.start_invincible(0.5)

	
	
	
	#print(hit_counter, ". Hit")
	
	
	if ((velocity.x > -30 && velocity.x < 30) && (velocity.y > -30 && velocity.y < 30)):
		#print(hit_counter, ". Hit when v = 0")
		knockback_vel = Vector2(-100, 100)
	else:
		knockback_vel = -velocity/1.3
	
	if (area.name == "NetHitbox"):
		knockback_vel = Vector2(100, 0)
	
	velocity = knockback_vel

		
	
	


func _on_PlayerStats_player_dead() -> void:
	
	#player_dead variable set to true to make sure that player
	#stops moving when dead
	player_dead = true


func _on_EndTimer_timeout() -> void:
	
	
	game_ended = true
	if (game_end_time == 0):
		game_end_time = OS.get_system_time_msecs()


func _on_MainScene_difficulty_1() -> void:
	start_glow = true


func _on_MainScene_difficulty_2() -> void:
	start_glow = false


func _on_MainScene_difficulty_3() -> void:
	start_glow = true


func _on_MainScene_difficulty_4() -> void:
	start_glow = false
