-- open iterm window, split and trigger commands in them
-- cerner_2tothe5th_2021
tell application "iTerm"
    -- have a iterm profile called Jumpgates with your settings
	set varWindow to create window with profile "Jumpgates"
	tell varWindow
		set varTab to current tab
		tell varTab
			set varSession to current session
			write varSession text "ssh prod-jg-1"
			
			set anotherSession to split vertically with same profile varSession
			write anotherSession text "ssh staging-jg-1"
			
			set yetAnotherSession to split vertically with same profile varSession
			write yetAnotherSession text "ssh staging-jg-1"
			
		end tell
	end tell
end tell
