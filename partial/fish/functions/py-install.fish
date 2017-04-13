function py-install
	pip wheel .; pip install --user --upgrade *py3*whl; rm *whl $argv;
end
