%%%-------------------------------------------------------------------
%% @doc Storage application
%% @end
%%%-------------------------------------------------------------------

-module(storage_system).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, stop/0, start/0]).

%%====================================================================
%% API
%%====================================================================

start() ->

%%application:start(crypto),
%%application:start(asn1),
%%application:start(public_key),
%%application:start(ssl),
%%application:start(ranch),
%%application:start(cowlib),
%%application:start(cowboy),

%%    ok = setup_cowboy(),
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
    ok = setup_cowboy(),
    storage_supervisor:start_link().

%%--------------------------------------------------------------------

stop() ->
    mnesia:stop(),
    application:stop(?MODULE).

stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

setup_cowboy() ->

    io:format("~n -------- setup cowboy ---------- ~n"),

    Dispatch = cowboy_router:compile([
        {'_', [{"/", hello_handler, []}]}
    ]),

    io:format("~n -------- routing set ---------- ~n"),

    R = cowboy:start_clear(
        http,
        [{port, 6666}],
        #{env => #{dispatch => Dispatch}}),


    io:format("~n -------- Cowboy started ---------- ~n ~p zzzzzzzzz", [R]),

    ok.