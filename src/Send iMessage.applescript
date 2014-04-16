on run argv
	set theHandle to item 1 of argv
	set theMessage to item 2 of argv
	tell application "Messages"
		set theService to first service whose service type is iMessage
		set theBuddy to first buddy that its service is theService and handle is theHandle
		send theMessage to theBuddy
	end tell
end run
