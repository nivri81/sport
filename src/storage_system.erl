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

    Dispatch = cowboy_router:compile([
        {'_', [{"/", hello_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    ok.