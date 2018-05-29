erl -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -name chunk_server_node1@192.168.1.104 -setcookies cookie -s mnesia create_schema chunk_server_node1@192.168.1.104 -s init stop

erl -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -pa /home/merk/dev/factorial_nodes/lib/factorial_app-0.2.0/ebin -boot /home/merk/dev/factorial_nodes/releases/1.0/start -name chunk_server_node1@192.168.1.104 -setcookies cookie
