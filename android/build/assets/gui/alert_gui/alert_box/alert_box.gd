extends GUI
class_name AlertBox

@onready var alert_label: Label = %AlertLabel
@onready var no: Button = %No
@onready var yes: Button = %Yes

# This has to be added onto UIManager

func _ready() -> void: 
	UIManager.layer += 1
	no.call_deferred("grab_focus")


func _on_no_pressed() -> void:
	_done()


func _on_yes_pressed() -> void:
	_done()


func _done():
	UIManager.layer -= 1
	UIManager.remove_gui($"../../..")

