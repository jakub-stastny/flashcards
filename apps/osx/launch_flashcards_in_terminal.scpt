#!/usr/bin/env osascript

tell application "Terminal"
	if not (exists window 1) then reopen

	activate
  delay 1
  tell application "System Events" to keystroke "k" using {command down}

  tell application "System Events" to keystroke "flashcards"
	tell application "System Events" to keystroke return

	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
	tell application "System Events" to keystroke "+" using {command down}
end tell
