-- Identify all Edge tabs having Github in the url and collate them into another Edge window
-- NOTE: This closes current open tabs in other windows, think we could use move operation although I didn't immediately succeed with that
-- so this essentially, open new tabs in a window to aggregate all GitHub tabs, and closes them in other windows 
-- it is idempotent so could rerun - as it ignores any window which it opens
-- also works with Chrome - replace Microsoft Edge with Google Chrome below..
-- cerner_2tothe5th_2022
if application "Microsoft Edge" is running then
	tell application "Microsoft Edge"
		tell application "Microsoft Edge"
			set newWin to make new window with properties {given name:"GitHub"}
		end tell
		repeat with current_window in every window
			set all_tabs to (every tab of current_window)
			if given name of current_window is not "GitHub" then
				repeat with current_tab in all_tabs
					if "GitHub" is in (URL of current_tab as string) then
						make new tab at newWin with properties {URL:URL of current_tab}
						close current_tab
					end if
				end repeat
			end if
		end repeat
	end tell
end if
