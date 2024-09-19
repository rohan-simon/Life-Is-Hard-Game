extends Sprite


var diff_1 : bool = false
var diff_2 : bool = false
var diff_3 : bool = false
var diff_4 : bool = false


func _ready() -> void:
	
	diff_1 = false
	diff_2 = false
	diff_3 = false
	diff_4 = false
	
	#Original is 0.6
	modulate.a = 0.0
	


func _physics_process(delta: float) -> void:
	
	if (diff_1 or diff_3):
		
		if (modulate.a < 0.60):
			
			modulate.a += 0.002
			
	elif (diff_2 or diff_4):
		
		if (modulate.a > 0):
			modulate.a -= 0.002
			



func _on_MainScene_difficulty_1() -> void:
	
	
	diff_1 = true


func _on_MainScene_difficulty_2() -> void:
	
	diff_1 = false
	diff_2 = true


func _on_MainScene_difficulty_3() -> void:
	
	diff_2 = false
	diff_3 = true


func _on_MainScene_difficulty_4() -> void:
	
	diff_3 = false
	diff_4 = true
