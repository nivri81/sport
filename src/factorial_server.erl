%%%-------------------------------------------------------------------
%%% @author merk
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 16:13
%%%-------------------------------------------------------------------
-module(factorial_server).
-author("merk").

-behaviour(gen_server).

%%%-------------------------------------------------------------------
%% User Interface Grouping
%%%-------------------------------------------------------------------
-export([start_link/0, stop/0, factorial/1, factorial/2]).

%%%-------------------------------------------------------------------
%% Gen Server Interface
%%%-------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%%===================================================================
%%% Client Call Functions
%%%===================================================================

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast({global, ?MODULE}, stop).

factorial(Value) ->
  gen_server:call({global, ?MODULE}, {factorial, Value}).

factorial(Value, IoDevice) ->
  gen_server:call({global, ?MODULE}, {factorial, Value, IoDevice}).

%%%===================================================================
%%% Call Back Functions
%%%===================================================================

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting .... ~n", [{global, ?MODULE}, self()]),
  {ok, []}.

handle_call({factorial, Value}, _From, State) ->
  {reply, factorial_logic:factorial(Value, 1), State};

handle_call({factorial, Value, IoDevice}, _From, State) ->
  {reply, factorial_logic:factorial(Value, 1, IoDevice), State};

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