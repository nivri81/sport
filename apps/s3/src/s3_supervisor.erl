%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 17:17
%%%-------------------------------------------------------------------
-module(s3_supervisor).
-author("grzegorz").

-behavior(supervisor).

%% API
-export([start_link/0, start_link_shell/0]).

-export([init/1]).

start_link_shell() ->
  {ok, Pid} = supervisor:start_link({global, ?MODULE}, ?MODULE, []),
  unlink(Pid).

start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init([]) ->
  s3_mnesia_logic:init(),
  io:format("~p (~p) starting ... ~n", [{global, ?MODULE}, self()]),

  %%  one_for_one, one_for_all

  RestartStrategy = one_for_all,
  MaxRestarts = 3,
  MaxSecondsBetweenRestarts = 5,
  Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  %%  permanent - always restart
  %%  temporary - never restart
  %%  transient - restart if abnormally ends
  Restart = permanent,

  %%  brutal_kill - use exit(Child, kill) to terminate
  %%  integer - use exit(Child, shutdown) - milliseconds
  Shutdown = infinity,

  %%  worker
  %%  supervisor
  Type = worker,

  StorageSpecifications = {storageChunkServerId, {s3_chunk_server, start_link, []}, Restart, Shutdown, Type, [storage_chunk_server]},

  %%  tuple of restart strategy, max restarts and max time
  %%  child specification
  {ok, {Flags, [StorageSpecifications ]}}.
