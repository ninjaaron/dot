# Defined in - @ line 0
function cpr --description 'alias cpr=cp --reflink=always -R'
	cp --reflink=always -R $argv;
end
