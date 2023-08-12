extends Node
class_name SeperatedLabelsLocalizerComponent

# Chain Reaction Atom Supreme
@export var text: String 
@export var chunks: Array[LabelChunk] 


func _ready() -> void: 
	update()
	
	
func update() -> void: 
	for chunk in chunks: 
		if chunk.chunk in text: 
			chunk.label.text = text.substr(text.find(chunk.chunk)) 
			
