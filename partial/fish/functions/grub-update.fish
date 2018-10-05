# Defined in - @ line 0
function grub-update --description 'alias grub-update=sudo grub-mkconfig -o /boot/grub/grub.cfg'
	sudo grub-mkconfig -o /boot/grub/grub.cfg $argv;
end
