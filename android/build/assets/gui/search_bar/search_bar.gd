extends TextEdit


var matches: Array[Control] 

@export var list: Control


func _on_text_changed() -> void:
	var items: Array[Node] = list.get_children() 
	var new_text: String = text.to_lower() 
	if new_text == "": 
		for i in items: 
			i.show()
		return 
	matches.clear() 
	for i in items: 
		if new_text in i.text.to_lower(): 
			matches.append(i)
	for i in items: 
		if i in matches: 
			i.show() 
		else: 
			i.hide()
