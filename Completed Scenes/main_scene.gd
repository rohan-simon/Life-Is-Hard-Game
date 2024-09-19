extends Node2D


#Exists to state when the game ends 


onready var end_timer = $EndTimer


var game_ended : bool = false

var curr_diff : String = ""

#Signals needed to change difficulty --> will result in obstacles
#moving faster + spawning faste

signal difficulty_1
signal difficulty_2
signal difficulty_3
signal difficulty_4

#To play background music

onready var background_music = $BackgroundMusicPlayer

onready var underwater_music = $BackgroundWater

onready var fade_in : Sprite = $FadeIn

func _ready() -> void:
	
	fade_in.modulate.a = 1
	
	game_ended = false
	
	#timer should be set at 300
	end_timer.start(300)
	
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if (fade_in.modulate.a > 0):
		fade_in.modulate.a -= 0.03
	
	
	if (background_music.playing == false):
		background_music.play()
	
	if (underwater_music.playing == false):
		underwater_music.play()
	
	#Difficulty1 --> so the first 60 minutes are technically difficulty_0
	if (end_timer.time_left < 60):
		emit_signal("difficulty_4")
		curr_diff = "difficulty_4"
		
	elif (end_timer.time_left < 120):
		emit_signal("difficulty_3")
		curr_diff = "difficulty_3"
		
		
	elif (end_timer.time_left < 180):
		emit_signal("difficulty_2")
		curr_diff = "difficulty_2"
		
	elif (end_timer.time_left < 240):
		emit_signal("difficulty_1")
		curr_diff = "difficulty_1"


	
	if (game_ended):
		
		
		
		if (background_music.volume_db > -80):
			background_music.volume_db -= 0.1
			
		if (underwater_music.volume_db > -80):
			
			underwater_music.volume_db -= 0.1
			
		
		if (background_music.volume_db <= -60):
			
			print("time to end")
			GlobalScript.back_to_menu(self)
			



func _on_Congrats_cue_music_dissappear() -> void:
	
	game_ended = true


func _on_DeathScreen_cue_music_dissappear() -> void:
	
	game_ended = true
