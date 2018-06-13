%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 17:17
%%%-------------------------------------------------------------------
-module(s3_chunk_supervisor).
-author("grzegorz").

-behavior(supervisor).

%% API
-export([start_link/0, start_link_shell/0]).

-export([init/1]).


start_link_shell() ->
  {ok, Pid} = supervisor:start_link({global, get_name()}, ?MODULE, []),
  unlink(Pid).

start_link() ->
  supervisor:start_link({global, get_name()}, ?MODULE, []).

init([]) ->

  s3_chunk_logic:init(),

  io:format("~p (~p) starting ... ~n", [{global, get_name()}, self()]),

  %%  one_for_one, one_for_all

  RestartStrategy = one_for_all,
  MaxRestarts = 50,
  MaxSecondsBetweenRestarts = 1,
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

  NodeName = atom_to_binary(node(), utf8),
  StorageSpecifications = { binary_to_atom(<<"server_", NodeName/binary>>, utf8), {s3_chunk_server, start_link, []}, Restart, Shutdown, Type, [storage_chunk_server]},

  %%  tuple of restart strategy, max restarts and max time
  %%  child specification
  {ok, {Flags, [StorageSpecifications]}}.

get_name() ->
  NodeName = atom_to_binary(node(), utf8),
  binary_to_atom(<<"supervisor_", NodeName/binary>>, utf8).