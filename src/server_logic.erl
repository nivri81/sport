%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 29. May 2018 21:43
%%%-------------------------------------------------------------------
-module(server_logic).
-author("grzegorz").

%% API
-export([write/2, read/1, delete/1]).

-define(CHUNK_SIZE, application:get_env(storage_system, chunk_size, 2)).
-define(CHUNK_NODES, application:get_env(storage_system, chunk_nodes, [])).

%%====================================================================
%% API
%%====================================================================

write(FileName, Data) ->
  io:format("Filename ~p, Data ~p, Chunk data size ~p ~n", [FileName, Data, ?CHUNK_SIZE]),
  Chunks = split(Data),
  io:format("Chunks ~p ~n", [Chunks]),

  %% split to chunks - read chunk size from configuration
  %% read nodes from configuration
  %% send chunks to nodes (in parallel II iteration )
  %% store information {chunks name, node} in local mnesia table
  ok.

read(FileName) ->

  io:format("Filename ~p ~n", [FileName]),
  io:format("~n -------------------------- ~n"),
  %% read chunks information from mnesia
  %% retrieve data from nodes (in parallel II iteration)
  %% sort chunks in right order
  ok.

delete(FileName) ->
  io:format("Filename ~p", [FileName]),
  io:format("~n -------------------------- ~n"),
  %% read chunks information from mnesia
  %% send request to remove all chunks (in parallel II iteration)
  %% remove record from mnesia
  ok.

%%====================================================================
%% Internal functions
%%====================================================================


-spec split(binary()) -> list().
split(Data) ->
  List = binary_to_list(Data),
  split( List, ?CHUNK_SIZE).

-spec split(list(), integer()) -> list().
split([], _) -> [];

split(List, Len) when Len > length(List) ->
  [List];

split(List, Len) ->
  {Head,Tail} = lists:split(Len, List),
  [Head | split(Tail, Len)].