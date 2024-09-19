extends Area2D

var invincible : bool = false setget set_invincible

#Used to get access to timer
onready var timer = $Timer

signal invincible_started
signal invincible_ended

#Called autonmatically when invincible changed
#Just done as setter -> no other purpose
func set_invincible(value):
	invincible = value
	
	if (invincible == true):
		emit_signal("invincible_started")
		
		######
		#print("invincible")
		######
		
	else:
		emit_signal("invincible_ended")
		
		######
		#print("not invincible")
		######

func start_invincible(duration):
	self.invincible = true
	timer.start(duration)
	




#invincibility must only be true for a short amount of time
#turns off when timer times out
func _on_Timer_timeout() -> void:
	
	#self needed because setter only activated within class 
	#if the keyword self is used
	self.invincible = false


func _on_Hurtbox_invincible_ended() -> void:
	set_deferred("monitorable", true)


func _on_Hurtbox_invincible_started() -> void:
	set_deferred("monitorable", false)
