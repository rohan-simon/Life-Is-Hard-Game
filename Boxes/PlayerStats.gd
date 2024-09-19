extends Node2D

export var max_health : int = 3

onready var health : int = max_health setget set_health


signal player_dead

signal change_health

#the setter will run automatically anytime the health value is changed
#any time the health value is changed/attempted to be changed
#this setter function is secretly called
func set_health(health_value):
	
	
	health = health_value
	
	emit_signal("change_health")
	
	
	if (health <= 0):
		emit_signal("player_dead")
	
