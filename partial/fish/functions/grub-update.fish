function grub-update
	sudo grub-mkconfig -o /boot/grub/grub.cfg $argv;
end
