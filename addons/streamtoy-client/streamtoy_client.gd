# The StreamToy client part
extends Node


# Emitted when StreamToy is properly connected to its backend
signal is_connected


# Whether the client is already connected to the backend
var is_connected: bool = false


# A list of handlers available on the client
var _handlers: Dictionary = {}

# The shared token to authenticate
var _token: String = ""

# The interval at which to send out heartbeat pings
var _heartbeat_interval = 150


# Connect to the StreamToy backend server
#
# #### Parameters
# - server_url: URL of the StreamToy backend server (use wss://-URLs)
# - token: The shared authentication token to authenticate to the backend
# - heartbeat_interval: The interval at which to send out heartbeat pings [150]
func connect_server(server_url: String, token: String, heartbeat_interval: int = 150) -> void:
	_token = token
	_heartbeat_interval = heartbeat_interval
	
	var peer = WebSocketClient.new()
	get_tree().connect("connected_to_server", self, "_on_connected")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	var error = peer.connect_to_url(
		server_url,
		PoolStringArray(),
		true
	)
	if error != OK:
		printerr("Error connecting to Streamtoy Server: %d" % error)
	get_tree().network_peer = peer


# Get a configured handler
func get_handler(handler_key: String):
	if handler_key in _handlers:
		return _handlers[handler_key]
	else:
		return null


# Event handler when the client is connected
func _on_connected():
	self.is_connected = true
	_handlers["auth"] = AuthHandler.new()
	_handlers["auth"].connect("auth_successful", self, "_add_handlers")
	_handlers["auth"].connect("auth_unsuccessful", self, "_auth_unsuccessful")
	_handlers["auth"].name = "Auth"
	get_tree().root.add_child(_handlers["auth"])
	get_node("/root/Auth").auth_client(self._token)
	

# We're connected and authenticated, add the required handlers
func _add_handlers():
	_handlers["ping"] = PingHandler.new(self._heartbeat_interval)
	_handlers["ping"].name = "Ping"
	get_tree().root.add_child(_handlers["ping"])
	_handlers["twitch"] = TwitchHandler.new()
	_handlers["twitch"].name = "StreamToyTwitch"
	get_tree().root.add_child(_handlers["twitch"])
	emit_signal("is_connected")


# The connection to the backend failed
func _on_connection_failed():
	printerr("Error connecting to Streamtoy server")


# The authentication to the backend failed
func _auth_unsuccessful():
	printerr("Can't authenticate to Streamtoy server")
