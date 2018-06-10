%%%-------------------------------------------------------------------
%% @doc Storage application
%% @end
%%%-------------------------------------------------------------------

-module(s3_chunk).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, stop/0, start/0]).

%%====================================================================
%% API
%%====================================================================

start() ->
    application:start(?MODULE).

start(_StartType, _StartArgs) ->
    s3_chunk_supervisor:start_link().

%%--------------------------------------------------------------------

stop() ->
    mnesia:stop(),
    application:stop(?MODULE).

stop(_State) ->
    ok.