# Defined in - @ line 0
function py-install --description 'alias py-install=pip wheel .; pip install --user --upgrade *py3*whl; rm *whl'
	pip wheel .; pip install --user --upgrade *py3*whl; rm *whl $argv;
end
