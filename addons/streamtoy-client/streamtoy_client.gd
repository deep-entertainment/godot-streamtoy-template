extends Node


signal is_connected


var _handlers: Dictionary = {}
var is_connected: bool = false


func connect_server(server_ip: String, server_port: int) -> void:
	var peer = NetworkedMultiplayerENet.new()
	get_tree().connect("connected_to_server", self, "_on_connected")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	var error = peer.create_client(server_ip, server_port)
	if error != OK:
		printerr("Error connecting to Streamtoy Server: %d" % error)
	get_tree().network_peer = peer


func get_handler(handler_key: String):
	if handler_key in _handlers:
		return _handlers[handler_key]
	else:
		return null


func _on_connected():
	self.is_connected = true
	_handlers["twitch"] = TwitchHandler.new()
	_handlers["twitch"].name = "StreamToyTwitch"
	get_tree().root.add_child(_handlers["twitch"])
	emit_signal("is_connected")

func _on_connection_failed():
	printerr("Error connecting to Streamtoy server")
