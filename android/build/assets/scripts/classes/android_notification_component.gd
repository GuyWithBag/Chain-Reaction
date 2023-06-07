extends Node
class_name AndroidNotificationComponent 

enum Notification {
	WM_GO_BACK_REQUEST
}

@export var function: Callable 

@export var _notif: Notification

func _notification(what: int) -> void: 
	match _notif: 
		Notification.WM_GO_BACK_REQUEST: 
			if what == Node.NOTIFICATION_WM_GO_BACK_REQUEST: 
				owner.pressed.emit()

