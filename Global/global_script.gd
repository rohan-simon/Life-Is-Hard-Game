extends Node





func back_to_menu(scene):
	
	scene.queue_free()
	get_tree().change_scene("res://Completed Scenes/main_menu.tscn")
