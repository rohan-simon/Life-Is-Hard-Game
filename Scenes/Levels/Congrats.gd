extends Sprite


#boolean to show end card
var show_end : bool = false

var start_time : int = 0


signal cue_music_dissappear

onready var black_out : Sprite = $BlackOut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_time = 0
	
	modulate.a = 0
	
	black_out.modulate.a = 0

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if (show_end):
		
		
		
		
		if (modulate.a < 1):
			modulate.a += 0.01
		
		else:
			
			if (start_time == 0):
				start_time = OS.get_system_time_msecs()
				
		
			if ((OS.get_system_time_msecs()) - start_time > 7000):
				
				emit_signal("cue_music_dissappear")
				
				if (black_out.modulate.a < 1):
					black_out.modulate.a += 0.015
				
	

func _on_Player_end_card() -> void:
	show_end = true
