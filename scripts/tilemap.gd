extends TileMap

const Status = {
	POWER_UP = 3,
	NORMAL = 2,
	SMALL = 1,
	DEAD = 0
}

const POWERUP_DATA_PATH = preload('res://scenes/PowerUp.tscn')
const FIRE_POWERUP_DATA_PATH = preload('res://scenes/FirePowerUp.tscn')

func hit(player_pos: Vector2, player_direction: int, status: int):
	var tile_pos = self.local_to_map(player_pos) - Vector2i(0, 1)
	var tile_data = self.get_cell_tile_data(0, tile_pos)
	
	if tile_data == null:
		tile_pos = self.local_to_map(player_pos + Vector2(32, 0)) - Vector2i(0, 1)
		tile_data = self.get_cell_tile_data(0, tile_pos)
		if tile_data == null:
			tile_pos = self.local_to_map(player_pos - Vector2(32, 0)) - Vector2i(0, 1)
			tile_data = self.get_cell_tile_data(0, tile_pos)
			if tile_data == null:
				return
	
	if not tile_data.get_custom_data("hittable"):
		return
	
	if not tile_data.get_custom_data("lucky_block"):
		if status > Status.SMALL:
			self.set_cell(0, tile_pos)
		return
	
	self.set_cell(0, tile_pos, 0, Vector2i(0, 1))
	if status < Status.POWER_UP:
		var powerup
		var powerup_pos = map_to_local(tile_pos - Vector2i(0, 1))
		if status == Status.SMALL:
			powerup =  POWERUP_DATA_PATH.instantiate()
			powerup.direction = player_direction
		elif status == Status.NORMAL:
			powerup = FIRE_POWERUP_DATA_PATH.instantiate()
		powerup.position = powerup_pos
		get_parent().add_child(powerup)
		return

func jump(player_pos: Vector2):
	var tile_pos = self.local_to_map(player_pos) - Vector2i(0, -1)
	var tile_data = self.get_cell_tile_data(0, tile_pos)
	
	if tile_data == null:
		tile_pos = self.local_to_map(player_pos + Vector2(32, 0)) - Vector2i(0, -1)
		tile_data = self.get_cell_tile_data(0, tile_pos)
		if tile_data == null:
			tile_pos = self.local_to_map(player_pos - Vector2(32, 0)) - Vector2i(0, -1)
			tile_data = self.get_cell_tile_data(0, tile_pos)
			if tile_data == null:
				return
	
	if tile_data.get_custom_data("jump_boost"):
		get_node("../Player").rebound(2000)
		return
