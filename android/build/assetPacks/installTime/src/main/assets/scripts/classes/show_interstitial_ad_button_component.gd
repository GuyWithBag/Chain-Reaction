extends Node

@export var id: AdID


func _ready() -> void: 
	get_parent().pressed.connect(_on_button_pressed)
	
	
func _on_button_pressed() -> void: 
	if AdsManager.interstitial_ad: 
		AdsManager.interstitial_ad.show()
		return
	AdsManager.ad_loaded.connect(
		func(ad: InterstitialAd): 
			ad.show()
	, CONNECT_ONE_SHOT
	)
	AdsManager.load_ad(id)
	pass

