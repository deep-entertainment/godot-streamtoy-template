tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("StreamToy", "res://addons/streamtoy-client/streamtoy_client.gd")


func _exit_tree() -> void:
	pass
