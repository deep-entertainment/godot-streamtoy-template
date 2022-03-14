# A handler connecting to the backend's twitch handler to subscribe to Twitch EventSub events
extends Node
class_name TwitchHandler


# We received a Twitch notification
#
# #### Parameters
# - type: The Twitch notification type
# - event: The event data
signal notification(type, event)


# A hash of subscriptions by subscription type
var _twitch_subscriptions: Dictionary = {}


# Subscribe to a new twitch event. 
# See https://dev.twitch.tv/docs/eventsub/eventsub-subscription-types
#
# #### Parameters
# - type: Event type to subscribe to
func subscribe(type: String, settings: Dictionary):
	rpc("twitch_subscribe", type, settings)


# Called by the backend to notify about a subscription event
#
# #### Parameters
# - subscription_id: ID of the subscription that received an event
# - event: The event data
remote func eventsub_notification(subscription_id: String, event: Dictionary):
	for sub_type in _twitch_subscriptions:
		if _twitch_subscriptions[sub_type] == subscription_id:
			emit_signal("notification", sub_type, event)


# Called by the backend to confirm that a subscription was confirmed by Twitch
#
# #### Parameters
# - subscription_id: Received subscription id
# - subscription_type: Type of subscription received
# - condition: Conditions received
# - version: Version number of the subscription type
remote func subscribed(
	subscription_id: String, 
	subscription_type: String, 
	condition: Dictionary, 
	version: String
):
	_twitch_subscriptions[subscription_type] = subscription_id
