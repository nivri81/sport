%%%-------------------------------------------------------------------
%% @doc Storage application
%% @end
%%%-------------------------------------------------------------------

-module(s3).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, stop/0, start/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
    ok = setup_cowboy(),
    s3_supervisor:start_link().

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
io:format(user, "User start ~p", [z]),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/file", s3_cowboy_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    ok.