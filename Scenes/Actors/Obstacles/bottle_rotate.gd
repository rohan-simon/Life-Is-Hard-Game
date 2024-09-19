extends KinematicBody2D


func _physics_process(delta: float) -> void:
	rotation += 1.5 * delta
