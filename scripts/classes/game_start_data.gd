extends Resource
class_name GameStartData

var map_data: MapData
var game_mode: GameMode
var player_amount: int


func _init(_map_data: MapData, _game_mode: GameMode, _player_amount: int) -> void:
	map_data = _map_data
	game_mode = _game_mode
	player_amount = _player_amount


