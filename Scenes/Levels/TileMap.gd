extends TileMap





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_collision_layer(2)


func _on_Player_turn_off_tilemap() -> void:
	set_collision_layer(64)
