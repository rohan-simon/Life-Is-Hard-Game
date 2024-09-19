extends Area2D


#Code to just let the enemy know when they can detect the player and when they can't
var player = null 


func can_see_player():
	
	#when the player is no longer within the area then it will be null again 
	
	return player != null


func _on_PlayerDetection_body_entered(body: Node) -> void:
	
	player = body


func _on_PlayerDetection_body_exited(body: Node) -> void:
	
	player = null
