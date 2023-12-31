extends Node

signal ad_loaded(ad: InterstitialAd)

var banner: AdView
var interstitial_ad : InterstitialAd
var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()


func _ready():
	interstitial_ad_load_callback.on_ad_failed_to_load = on_interstitial_ad_failed_to_load
	interstitial_ad_load_callback.on_ad_loaded = on_interstitial_ad_loaded


func load_show_banner(id: AdID, size: AdSize, position: AdPosition.Values) -> void: 
	var ad_view: AdView = AdView.new(id.get_id(), size, position)
	ad_view.load_ad(AdRequest.new())
	banner = ad_view


func load_ad(id: AdID) -> void:
	if interstitial_ad:
		#always call this method on all AdFormats to free memory on Android/iOS
		interstitial_ad.destroy()
		interstitial_ad = null
	
	InterstitialAdLoader.new().load(id.get_id(), AdRequest.new(), interstitial_ad_load_callback)


func on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	printerr(adError.message)


func on_interstitial_ad_loaded(_interstitial_ad : InterstitialAd) -> void:
	interstitial_ad = _interstitial_ad
	ad_loaded.emit(interstitial_ad)
	
	
