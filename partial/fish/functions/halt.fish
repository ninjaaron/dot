# Defined in - @ line 0
function halt --description 'alias halt=systemctl poweroff'
	systemctl poweroff $argv;
end
