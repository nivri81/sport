REBAR=rebar3
ERL=erl

test :
	$(REBAR) eunit

compile :
	$(REBAR) compile

dev : compile
#	$(ERL) -config sys.config -pa _build/default/lib/storage_system/ebin
	$(ERL) -config sys.config -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -name chunk_server_node1@192.168.1.104 -setcookies cookie -s mnesia create_schema chunk_server_node1@192.168.1.104 -s init stop
	$(ERL) -config sys.config -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -pa _build/default/lib/storage_system/ebin  -pa _build/default/lib/sync/ebin -name chunk_server_node1@192.168.1.104 -setcookies cookie -s sync go -s storage_system


