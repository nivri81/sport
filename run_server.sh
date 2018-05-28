erl -mnesia dir '"/tmp/mnesia/server"' -name server@192.168.1.104 -setcookies cookie -s mnesia create_schema server@192.168.1.104 -s init stop

erl -mnesia dir '"/tmp/mnesia/server"' -pa /home/merk/dev/factorial_nodes/lib/factorial_app-0.2.0/ebin -boot /home/merk/dev/factorial_nodes/releases/1.0/start -name server@192.168.1.104 -setcookies cookie
