extends Sprite


var show_death_screen : bool = false

onready var black_out : Sprite = $BlackOut


var start_time : int = 0


signal cue_music_dissappear

func _ready() -> void:
	
	start_time = 0
	
	
	modulate.a = 0
	
	black_out.modulate.a = 0

func _process(delta: float) -> void:
	
	
	
	if (show_death_screen):
		
		
		
		
		
	
		
		
		
		if (modulate.a < 1):
			modulate.a += 0.01
		
		else:
			
			if (start_time == 0):
				start_time = OS.get_system_time_msecs()
			
	
			if ((OS.get_system_time_msecs() - start_time) > 7000):
				
				emit_signal("cue_music_dissappear")
		
				if (black_out.modulate.a < 1):
			
					black_out.modulate.a += 0.015
		

func _on_Player_death_screen() -> void:
	show_death_screen = true
	
	
