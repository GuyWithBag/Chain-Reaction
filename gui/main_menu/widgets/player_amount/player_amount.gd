extends CenterContainer
class_name PlayerAmountSelector

signal player_amount_changed(previous_amount: int, new_amount: int)

var player_amount: int = 2: 
	set(value): 
		var previous_amount: int = player_amount
		player_amount = clamp(value, 2, 999999)
		players_amount_label.text = str(player_amount)
		player_amount_changed.emit(previous_amount, player_amount)

@onready var hbox_container: HBoxContainer = get_node("HBoxContainer")
@onready var players_amount_label: Label = hbox_container.get_node("PlayersAmount")


func _on_more_pressed() -> void:
	player_amount += 1


func _on_less_pressed() -> void:
	player_amount -= 1
