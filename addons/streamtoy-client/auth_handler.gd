# Handler connecting to the StreamToy backend's auth handler
# to send an authentication message once connected
extends Node
class_name AuthHandler


# Emitted when the authentication was successful
signal auth_successful

# Emitted when the authentication was not successful
signal auth_unsuccessful


# Authenticate the client with the given token
func auth_client(token):
	rpc('auth', token)


# Remote function called by the backend to say, that the authentication was successful
remote func auth_successful():
	emit_signal("auth_successful")
	

# Remote function called by the backend to say, that the authentication was not sucessful
remote func auth_unsuccessful():
	emit_signal("auth_unsuccessful")
