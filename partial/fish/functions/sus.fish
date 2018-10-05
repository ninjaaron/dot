# Defined in - @ line 0
function sus --description 'alias sus=systemctl suspend'
	systemctl suspend $argv;
end
