extends Resource
class_name GameStartData

var map_data: MapData
var game_mode: GameMode
var player_amount: int
var extend_map: bool = false


func _init(_game_mode: GameMode, _player_amount: int, _map_data: MapData = null, _extend_map: bool = false, ) -> void:
	game_mode = _game_mode
	player_amount = _player_amount
	extend_map = _extend_map
	map_data = _map_data
