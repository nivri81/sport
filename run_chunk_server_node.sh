erl -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -name chunk_server_node1@192.168.1.104 -setcookies cookie -s mnesia create_schema chunk_server_node1@192.168.1.104 -s init stop
erl -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -pa _build/default/lib/storage_system/ebin -name chunk_server_node1@192.168.1.104 -setcookies cookie
