REBAR=rebar3
ERL=erl

test :
	$(REBAR) eunit

compile :
	$(REBAR) compile

dev : compile
#	$(ERL) -config sys.config -pa _build/default/lib/sport/ebin -s sport_app start
	$(ERL) -config sys.config -pa _build/default/lib/factorial_app/ebin

#-s factorial_app start


