function trans
	ssh -fNT -L 9091:localhost:9091 sink $argv;
end
