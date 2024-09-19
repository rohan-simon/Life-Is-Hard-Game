extends Control


var hearts = 0 setget set_hearts

onready var heartUI = $HeartUI

var health_disappear : bool = false

func _ready() -> void:
	
	self.hearts = 3


func _process(delta: float) -> void:
	if (health_disappear):
		
		if (modulate.a > 0):
			modulate.a -= 0.05

func set_hearts(value):
	
	hearts = value
	
	if heartUI != null:
		heartUI.rect_size.x = hearts * 85
	
	
	
	
	
func _on_PlayerStats_change_health() -> void:
	self.hearts -= 1


func _on_Player_health_disappear() -> void:
	health_disappear = true
