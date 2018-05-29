%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 20:42
%%%-------------------------------------------------------------------
-module(storage_chunk_server).
-author("grzegorz").

%% API
-export([]).

-behaviour(gen_server).

%%%-------------------------------------------------------------------
%% User Interface Grouping
%%%-------------------------------------------------------------------
-export([start_link/0, stop/0, write/2, read/1, delete/1]).

%%%-------------------------------------------------------------------
%% Gen Server Interface
%%%-------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%%%===================================================================
%%% Client Call Functions
%%%===================================================================

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:cast({global, ?MODULE}, stop).

write(Key, Data) ->
  gen_server:call( {global, ?MODULE}, {write, Key, Data}).

read(Key) ->
  gen_server:call( {global, ?MODULE}, {read, Key}).

delete(Key) ->
  gen_server:call( {global, ?MODULE}, {delete, Key}).

%%%===================================================================
%%% Call Back Functions
%%%===================================================================

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting .... ~n", [{global, ?MODULE}, self()]),
  storage_chunk_logic:init(),
  {ok, #state{}}.

handle_call({write, Key, Data}, _From, State) ->
  Result = storage_chunk_logic:write(Key, Data),
  {reply, Result, State};

handle_call({read, Key}, _From, State) ->
  Data = storage_chunk_logic:read(Key),
  {reply, Data, State};

handle_call({delete, Key}, _From, State) ->
  Result = storage_chunk_logic:delete(Key),
  {reply, Result, State};

handle_call(_Request, _From, State) ->
  {reply, i_don_t_know, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(Info, State) ->
  {noreply, Info, State}.

terminate(_Reason, _State) ->
  io:format("terminating ~p ~n", [{local, ?MODULE}]),
  ok.

code_change(_OldVersion, State, _Extra) ->
  {ok, State}.