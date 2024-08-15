extends OptionListTile

var player_color_picker: PackedScene = load("res://gui/options_menu/widget/player_color_picker/player_color_picker.tscn") 

@onready var players: VBoxContainer = get_node("%PlayersList")
@onready var max_undos: HBoxContainer = get_node("%MaxUndos")
@onready var max_undos_spinbox: SpinBox = max_undos.get_node("SpinBox") 


func _ready() -> void: 
	init() 
	
	
func init() -> void: 
	if players == null: 
		await ready 
	var sort_by_highest: Callable = func(a, b): 
		if a < b: 
			return true
		return false
		
	var player_colors: Dictionary = PlayersManager.player_colors 
	for player in players.get_children(): 
		player.queue_free() 
		
	# Arrange them in order because they are from a dictionary. 
	var new_player_numbers: Array[int] = []
	for key in player_colors.keys(): 
		new_player_numbers.append(int(key))
	new_player_numbers.sort_custom(sort_by_highest)
	
	for player_number in new_player_numbers: 
		add_player(player_number)
	#max_undos_spinbox.value = UndoHistoryManager.max_undos
	


func _on_add_more_players_pressed() -> void: 
	add_player(players.get_child_count() + 1) 


func _on_spin_box_value_changed(value: float) -> void:
	#UndoHistoryManager.max_undos = int(value) 
	pass


func add_player(player_number: int) -> void: 
	var color_picker: PlayerColorPicker = player_color_picker.instantiate()
	players.add_child(color_picker) 
	color_picker.player_number = player_number
	if PlayersManager.player_colors.has(str(player_number)): 
		color_picker.color_picker_button.color = PlayersManager.player_colors[str(player_number)]
