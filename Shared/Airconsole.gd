extends Node

# inst will hold a reference to the AirConsole client or server.
# This works around the way the problem that we can not specify the Autoload
# type to be two different types in one project.
var inst = null

# Run in browser without AriConsole? Set this to true for offline debugging and
# profiling in the browser. Running without a browser is supported by defualt.
var offlineDebug = false
