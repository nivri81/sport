%%%-------------------------------------------------------------------
%%% @author merk
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 20:42
%%%-------------------------------------------------------------------
-module(database_server).
-author("merk").

%% API
-export([]).

-behaviour(gen_server).

%%%-------------------------------------------------------------------
%% User Interface Grouping
%%%-------------------------------------------------------------------
-export([start_link/0, stop/0, store/2, getDB/1, getDBTwo/1, delete/1]).

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

store(NodeName, Comment) ->
  gen_server:call( {global, ?MODULE}, {store, NodeName, Comment}).

getDB(NodeName) ->
  gen_server:call( {global, ?MODULE}, {getDB, NodeName} ).

getDBTwo(NodeName) ->
  gen_server:call( {global, ?MODULE}, {getDBTwo, NodeName} ).

delete(NodeName) ->
  gen_server:call( {global, ?MODULE}, {delete, NodeName} ).


%%%===================================================================
%%% Call Back Functions
%%%===================================================================

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting .... ~n", [{global, ?MODULE}, self()]),
  database_logic:initDB(),
  {ok, #state{}}.

handle_call({store, NodeName, Comment}, _From, State) ->
  Result = database_logic:storeDB(NodeName, Comment),
%%  io:format("Comment has been stored for ~p ~n", [NodeName]),
  {reply, Result, State};

handle_call({getDB, NodeName}, _From, State) ->
  Comments = database_logic:getDB(NodeName),
%%  lists:foreach(fun(CM) -> io:format("Received ~p ~n", [CM]) end, Comments),
  {reply, Comments, State};

handle_call({getDBTwo, NodeName}, _From, State) ->
  Comments = database_logic:getDBTwo(NodeName),

%%  lists:foreach(
%%    fun({CM, CreatedOn}) -> io:format("Received ~p created on ~p ~n", [CM, CreatedOn]) end,
%%    Comments),

  {reply, Comments, State};

handle_call({delete, NodeName}, _From, State) ->
  database_logic:deleteDB(NodeName),
   io:format("Data deleted for ~p ~n", [NodeName]),
  {reply, ok, State};

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