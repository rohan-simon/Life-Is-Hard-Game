extends StaticBody2D


onready var animate : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	
	animate.set_speed_scale(0.5)
	animate.play("up_down")

