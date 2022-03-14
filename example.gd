# Example implementation of using StreamToy
# Please adapt to your needs
# 
# This scene includes a RichTextLabel that shows a bbcode-based text animation when
# an event is received.
extends Control


# Connect to the StreamToy server
func _ready() -> void:
	get_tree().get_root().set_transparent_background(true)
	OS.window_per_pixel_transparency_enabled = true
	StreamToy.connect("is_connected", self, "_is_connected")
	StreamToy.connect_server(
		OS.get_environment("STREAMTOY_URL"),
		OS.get_environment("STREAMTOY_TOKEN")
	)
	$RichTextLabel.text = ""
	

# We're connected, subscribe to twitch events
func _is_connected():
	StreamToy.get_handler("twitch").connect("notification", self, "_on_StreamtoyClient_notification")
	StreamToy.get_handler("twitch").subscribe(
		"channel.follow", 
		{
			"broadcaster_user_id": OS.get_environment("STREAMTOY_TWITCH_USER_ID")
		}
	)
	StreamToy.get_handler("twitch").subscribe(
		"channel.raid", 
		{
			"broadcaster_user_id": OS.get_environment("STREAMTOY_TWITCH_USER_ID")
		}
	)


# We received a event, handle it
#
# #### Parameters
# - type: Type of event received
# - event: Event received
func _on_StreamtoyClient_notification(type: String, event: Dictionary) -> void:
	var text = ""
	
	if type == "channel.raid":
		text = "%s raided with %s viewers!" % [
			event.from_broadcaster_user_name,
			event.viewers
		]
	elif type == "channel.follow":
		text = "%s followed the channel" % event.user_name
	
	$RichTextLabel.bbcode_text = "[rainbow freq=1.2 sat=10 val=20][center][wave amp=50 freq=10]%s[/wave][/center][/rainbow]" % [
		text
	]
	
	yield(get_tree().create_timer(3),"timeout")
	$RichTextLabel.bbcode_text = ""
