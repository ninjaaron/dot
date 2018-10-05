# Defined in - @ line 0
function reboot --description 'alias reboot=systemctl reboot'
	systemctl reboot $argv;
end
