extends Node

@export var interstitial_ad_id: String = "standard"
@export var destroy_banner: bool = false


func _ready() -> void: 
	get_parent().pressed.connect(_on_button_pressed)
	
	
func _on_button_pressed() -> void: 
	if destroy_banner: 
		MobileAds.destroy_banner()
	printerr("AAAAAAAAAAAA")
	MobileAds.load_interstitial(interstitial_ad_id)
	MobileAds.show_interstitial() 


