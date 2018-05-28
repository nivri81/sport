%%%-------------------------------------------------------------------
%% @doc factorial public API
%% @end
%%%-------------------------------------------------------------------

-module(factorial_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start/0, stop/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
    factorial_supervisor:start_link().

%%--------------------------------------------------------------------

stop() ->
    mnesia:stop(),
    application:stop(?MODULE).

stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
