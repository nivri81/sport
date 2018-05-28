# erl -mnesia dir '"/tmp/mnesia/node1"' -name node1@192.168.1.104 -setcookies cookie -s mnesia create_schema node1@192.168.1.104 -s init stop

# erl -mnesia dir '"/tmp/mnesia/node1"' -pa /home/merk/dev/factorial_nodes/lib/factorial_app-0.2.0/ebin -boot /home/merk/dev/factorial_nodes/releases/1.0/start -name node1@192.168.1.104 -setcookies cookie


erl -name node1@192.168.1.104 -setcookies cookie 