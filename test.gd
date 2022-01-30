extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StreamToy.connect("is_connected", self, "_is_connected")
	StreamToy.connect_server("localhost", 8081)
	$RichTextLabel.text = ""
	

func _is_connected():
	StreamToy.get_handler("twitch").twitch_broadcaster_user_id = "12826"
	StreamToy.get_handler("twitch").subscribe()
	StreamToy.get_handler("twitch").connect("notification", self, "_on_StreamtoyClient_notification")


func _on_StreamtoyClient_notification(type, event) -> void:
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
	
