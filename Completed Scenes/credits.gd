extends MarginContainer


#There is only one option in the credits screen
#So when the user pressed enter they should go back to the main screen

var change_scene : bool = false

onready var enter_sound : AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	change_scene = false

func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("menu_enter")):
		
		change_scene = true
		
		enter_sound.play()
	
	if (!enter_sound.playing and change_scene):
		get_tree().change_scene("res://Completed Scenes/main_menu.tscn")
	
	
