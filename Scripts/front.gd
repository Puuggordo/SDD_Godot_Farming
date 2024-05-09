extends TileMap


func _on_belowstall_body_entered(_body):
	z_index = 0


func _on_abovestall_body_entered(_body):
	z_index = 2
