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
	@$(REBAR) auto --config sys.config --name chunk_server_node1@192.168.1.104 --setcookie cookie