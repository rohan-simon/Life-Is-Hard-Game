extends MarginContainer


onready var selector_1 : Label = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Selector1
onready var selector_2 : Label = $CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Selector2

onready var sound_effect : AudioStreamPlayer = $OptionSound
onready var enter_sound : AudioStreamPlayer = $EnterSound

#Want menu scrren to fade-in
onready var fade_in = $FadeIn

var curr_selection : int = 0

#Keeps track of options on menu screen --> 0-based counting 
var max_num_options : int = 1

#Used to make sure music is done playing before scene is switched
var switch_scene : bool = false


#OPTIONS:
#  0 is 'START'
#  1 is 'CREDITS'

func _ready() -> void:
	
	
	fade_in.modulate.a = 1
	switch_scene = false
	
	#The first seleciton should be the first option
	set_curr_selection(0)
	

func _process(delta: float) -> void:
	
	if (fade_in.modulate.a > 0):
		
		fade_in.modulate.a -= 0.005
	

	#Current selection/options shouldn't change if they try
	#to go up or down from the top and bottom option respectively
	if (Input.is_action_just_pressed("menu_down") and curr_selection < max_num_options):
		curr_selection += 1
		
		sound_effect.play()
		
		set_curr_selection(curr_selection)
	
	#If current selection is equal to 0 it means they are already at the top option
	elif (Input.is_action_just_pressed("menu_up") and curr_selection > 0):
		
		curr_selection -= 1
		
		sound_effect.play()
		
		set_curr_selection(curr_selection)
	
	elif (Input.is_action_just_pressed("menu_enter")):
		
		switch_scene = true
		
		enter_sound.play()
		
		
	#Makes sure that the sound has stopped playing and it is time to switch scene
	
	if (!enter_sound.playing and switch_scene):
		handle_selection(curr_selection)
	


func set_curr_selection(selection : int):
	
	#Arrow only appears on the selected option --> 0 represents 'start', 1 represents 'credits'
	
	selector_1.text = ""
	selector_2.text = ""
	
	
	if (selection == 0):
		selector_1.text = ">"
	elif (selection == 1):
		selector_2.text = ">"

func handle_selection(selection : int):
	
	if (selection == 0):
		
		get_tree().change_scene("res://Completed Scenes/main_scene.tscn")
		
	elif (selection == 1):
		
		get_tree().change_scene("res://Completed Scenes/credits.tscn")
		
	
