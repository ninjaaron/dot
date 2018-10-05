# Defined in - @ line 0
function pSyu --description 'alias pSyu=sudo ~/bin/rsnap2 -k 3 -m / /rootvol /snapshots; sudo pacmatic -Syu; pacman -Qu | wc -l | int2byte > ~/.updates'
	sudo ~/bin/rsnap2 -k 3 -m / /rootvol /snapshots; sudo pacmatic -Syu; pacman -Qu | wc -l | int2byte > ~/.updates $argv;
end
