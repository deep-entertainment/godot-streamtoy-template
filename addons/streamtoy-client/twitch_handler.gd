extends Node
class_name TwitchHandler

signal notification(type, event)


var twitch_broadcaster_user_id: String = ""


var _twitch_subscriptions: Dictionary = {}


func subscribe():
	if self.twitch_broadcaster_user_id != "":
		_twitch_subscribe()


func _twitch_subscribe():
	print("Subscribing to twitch events")
	rpc("twitch_subscribe", "channel.follow", {
		"broadcaster_user_id": twitch_broadcaster_user_id
	})
	
	rpc("twitch_subscribe", "channel.raid", {
		"broadcaster_user_id": twitch_broadcaster_user_id
	})
	

remote func eventsub_notification(subscription_id: String, event: Dictionary):
	print_debug("Notification for subscription %s received" % subscription_id)
	for sub_type in _twitch_subscriptions:
		print_debug("Checking %s" % sub_type)
		if _twitch_subscriptions[sub_type] == subscription_id:
			print_debug("Matched. Emitting notification signal")
			emit_signal("notification", sub_type, event)


remote func subscribed(
	subscription_id: String, 
	subscription_type: String, 
	condition: Dictionary, 
	version: String
):
	print("Received subscription %s for %s/%s with conditions %s" % [
		subscription_id,
		version,
		subscription_type,
		JSON.print(condition)
	])
	_twitch_subscriptions[subscription_type] = subscription_id
