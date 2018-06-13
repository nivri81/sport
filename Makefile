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


rel : clean compile
	@$(REBAR) release -n s3
	@$(REBAR) release -n s3_chunk

node1:
	$(ERL) -config sys_test.config -mnesia dir '"/tmp/mnesia/node1"' -pa _build/default/lib/**/ebin -name chunk_node1@192.168.1.104 -setcookie cookie -s s3_chunk

node2:
	@$(ERL) -config sys_test.config -mnesia dir '"/tmp/mnesia/node2"' -pa _build/default/lib/**/ebin -name chunk_node2@192.168.1.104 -setcookie cookie -s s3_chunk

node3:
	@$(ERL) -config sys_test.config -mnesia dir '"/tmp/mnesia/node3"' -pa _build/default/lib/**/ebin -name chunk_node3@192.168.1.104 -setcookie cookie -s s3_chunk

rest:
	@$(REBAR) shell --config sys_test.config --name server@192.168.1.104 --setcookie cookie
