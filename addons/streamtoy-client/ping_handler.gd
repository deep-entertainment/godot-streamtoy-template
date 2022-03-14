# A handler connecting to the StreamToy backend to send out heartbeat pings every once
# in a while
extends Node
class_name PingHandler


# The interval at which to send out heartbeat things. Obviously needs to be smaller than
# the backend's client timeout
var _heartbeat_interval = 150


func _init(heartbeat_interval: int):
	_heartbeat_interval = heartbeat_interval
	

# Setup and start the timer to send out heartbeat pings
func _enter_tree():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_ping")
	timer.start(self._heartbeat_interval)


# Actually send out a heartbeat ping by calling the backend function
func _ping():
	rpc("ping")
