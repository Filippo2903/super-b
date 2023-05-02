extends TileMap

const POWERUP_DATA_PATH = preload('res://scenes/PowerUp.tscn')

func hit(player_pos: Vector2, player_direction: int):
	var tile_pos = self.local_to_map(player_pos) - Vector2i(0, 1)
	var tile_data = self.get_cell_tile_data(0, tile_pos)
	if tile_data == null:
		hit(player_pos - Vector2(64, 0), player_direction)
		return
	
	if not tile_data.get_custom_data("hittable"):
		return
	
	if not tile_data.get_custom_data("lucky_block"):
		self.set_cell(0, tile_pos)
		return
	
	self.set_cell(0, tile_pos, 0, Vector2i(0, 1))
	var powerup_pos = map_to_local(tile_pos - Vector2i(0, 1)) + Vector2(32, 6)
	var powerup = POWERUP_DATA_PATH.instantiate()
	powerup.position = powerup_pos
	powerup.direction = player_direction
	get_parent().add_child(powerup)
