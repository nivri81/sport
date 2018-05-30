REBAR=rebar3
ERL=erl

test :
	$(REBAR) eunit

clean :
	@echo "Cleaning ...."
	@rm -rf _build/*

compile :
	@echo "Compiling ...."
	$(REBAR) compile

dev : compile
	@echo "Starting ...."
	@$(ERL) -config sys.config -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -name chunk_server_node1@192.168.1.104 -setcookies cookie -s mnesia create_schema chunk_server_node1@192.168.1.104 -s init stop
	@$(ERL) -config sys.config -mnesia dir '"/tmp/mnesia/chunk_server_node1"' -pa _build/default/lib/*/ebin -pa _build/default/plugins/*/ebin -name chunk_server_node1@192.168.1.104 -setcookie cookie -s sync go -s storage_system
	#-s ranch -s cowlib -s cowboy -s storage_system


