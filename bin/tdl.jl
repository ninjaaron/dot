#!/usr/bin/env julia
shquote(s) = "'$(replace(s, "'", "'\"'\"'"))'" 
struct Torrent
    id
    perc
    have
    eta
    up
    down
    ratio
    status
    name
end

function main()
    server = ARGS[1]
    target = Regex(ARGS[2], "i")
    torrents = (Torrent(split(strip(t), r" {2,}", limit=9)...) for t in
                readlines(`ssh $server transmission-remote -l`)[2:end-1])
    matches = (t for t in torrents
               if search(t.name, target) != 0:-1 && t.perc == "100%")

    for torrent in matches
        filename = "$server:dls/$(shquote(torrent.name))"
        run(`sftp -ar $filename .`)
    end
end

main()
