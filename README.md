![](icon.png)
# Streamtoy client

StreamToy is a framework for attaching a Godot based applications and games to a streamer service to trigger actions in Godot when certain events in streams happen.

This repository holds the StreamToy client and a reference application that connects to a [StreamToy](https://github.com/deep-entertainment/godot-stream-toy) server
and subscribes to twitch events.

If a twitch event is received, a short bbcode-label animation is presented.

This is a reference implementation of a StreamToy frontend and is the base of the StreamToy game template.

To test this application against your stream, set the following environment variables when running the application:

* STREAMTOY_URL: URL to the streamtoy server (use the wss:// protocol)
* STREAMTOY_TOKEN: Shared authentication token
* STREAMTOY_TWITCH_USER_ID: Twitch user id to follow in the test application

# Warning for production use

This repository includes an export preset for an HTML export. If you add an export template that includes private data, please ignore the export_presets.cfg file
in the .gitignore.

# Issues

See the [deep entertainment issues repository](https://github.com/deep-entertainment/issues/issues) if you have problems or new ideas for the project.


