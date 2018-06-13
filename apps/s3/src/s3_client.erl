%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 29. May 2018 21:43
%%%-------------------------------------------------------------------
-module(s3_client).
-author("grzegorz").

%% API
-export([write/2, read/1, delete/1]).

-define(CHUNK_SIZE, application:get_env(s3, chunk_size, 2)).
-define(CHUNK_NODE_LISTS, application:get_env(s3, chunk_nodes, [])).

%%====================================================================
%% API
%%====================================================================

%% -------------------------------------------------------------------
%% @doc Store file
%% -------------------------------------------------------------------
-spec write(FileName :: binary(), Data :: any()) -> ok.
write(FileName, Data) ->
  Chunks = split(Data),
  ListOfChunksWithNodes = assign_chunks_to_nodes( FileName, Chunks, ?CHUNK_NODE_LISTS),
  ok = store_chunks_on_nodes(ListOfChunksWithNodes),
  false = s3_mnesia_logic:file_exists(FileName),

  ok = s3_mnesia_logic:store_file_metadata(FileName, ListOfChunksWithNodes),
  ok.

%% -------------------------------------------------------------------
%% @doc Read file
%% -------------------------------------------------------------------
-spec read(FileName :: binary()) -> binary().
read(FileName) ->
  true = s3_mnesia_logic:file_exists(FileName),
  KeyNodeList = s3_mnesia_logic:read_key_node_list(FileName),
  KeyDataList = [ {Key, read_chunk_on_node(Key, Node)} || {Key, Node} <- KeyNodeList],


  io:format("Co to ~p ~n", [KeyDataList]),

  DataList = [ Data || {_Key, Data} <- KeyDataList],
  FileContent = list_to_binary(DataList),
  FileContent.

%% -------------------------------------------------------------------
%% @doc Delete file
%% -------------------------------------------------------------------
-spec delete(FileName :: binary()) -> ok.
delete(FileName) ->
  true = s3_mnesia_logic:file_exists(FileName),
  KeyNodeList = s3_mnesia_logic:read_key_node_list(FileName),
  [ok = delete_chunk_on_node(Key, Node) || {Key, Node} <- KeyNodeList],
  ok = s3_mnesia_logic:delete_metadata(FileName),
  ok.

%%====================================================================
%% Internal functions
%%====================================================================

%% -------------------------------------------------------------------
%% @doc split binary data into chunks, chunk size taken from config
%% -------------------------------------------------------------------
-spec split(binary()) -> list().
split(Data) ->
  List = binary_to_list(Data),
  split( List, ?CHUNK_SIZE).

%% -------------------------------------------------------------------
%% @doc split binary data into chunks, chunk size taken from arg
%% -------------------------------------------------------------------
-spec split(list(), integer()) -> list().
split([], _) -> [];

split(List, Len) when Len > length(List) ->
  [List];

split(List, Len) ->
  {Head, Tail} = lists:split(Len, List),
  [ list_to_binary(Head) | split(Tail, Len)].

%% -------------------------------------------------------------------
%% @doc combine chunks data with nodes into list of tuples [{Key, Node, Data}]
%% -------------------------------------------------------------------
-spec assign_chunks_to_nodes(binary(), list(), list()) -> list().
assign_chunks_to_nodes(FileName, Chunks, Nodes) ->
  assign_chunks_to_nodes(FileName, Chunks, Nodes, 1, []).

%% -------------------------------------------------------------------
%% @doc combine chunks data with nodes into list of tuples [{Key, Node, Data}]
%% -------------------------------------------------------------------
-spec assign_chunks_to_nodes(binary(), list(), list(), integer(), list()) -> list().
assign_chunks_to_nodes(_FileName, [], _Nodes, _CurrentNodePosition, Acc) ->
  Acc;

assign_chunks_to_nodes(FileName, [ChunkData|Chunks], Nodes, CurrentNodePosition, Acc) ->

  CurrentNode = lists:nth(CurrentNodePosition, Nodes),
  NextNodePosition = case CurrentNodePosition >= length(Nodes) of
                       true -> 1;
                       _ -> CurrentNodePosition + 1
                     end,

  CurrentIndex = integer_to_binary(length(Acc) + 1),
  ChunkKey = <<FileName/binary, <<"_">>/binary, CurrentIndex/binary >>,
  ChunkWithMetadata = { ChunkKey , CurrentNode, ChunkData},
  assign_chunks_to_nodes( FileName, Chunks, Nodes, NextNodePosition, Acc ++ [ChunkWithMetadata] ).

%% -------------------------------------------------------------------
%% @doc send chunks to the assigned nodes
%% -------------------------------------------------------------------
-spec store_chunks_on_nodes( list()) -> ok.
store_chunks_on_nodes(ListOfChunksWithNodes) ->
  [ store_chunk_on_node(ChunkMetaData) || ChunkMetaData <- ListOfChunksWithNodes ],
  ok.

%% -------------------------------------------------------------------
%% @doc send chunks to the assigned node
%% -------------------------------------------------------------------
-spec store_chunk_on_node( {binary(), atom(), binary()}) -> ok.
store_chunk_on_node({ Key, Node, Data}) ->
  ok = rpc:call( Node, s3_chunk_client, write, [Key, Data]),
  io:format("Data has been stored, node: ~p, key: ~p, data: ~p ~n", [Node, Key, Data]),
  ok.

%% -------------------------------------------------------------------
%% @doc read chunk from the node
%% -------------------------------------------------------------------
-spec read_chunk_on_node( binary(), atom()) -> binary().
read_chunk_on_node( Key, Node ) ->



  ChunkData = rpc:call( Node, s3_chunk_client, read, [Key]),
  io:format("Data has been read: node: ~p, key: ~p, data: ~p  ~n", [Node, Key, ChunkData]),
  ChunkData.

%% -------------------------------------------------------------------
%% @doc remove chunk from node
%% -------------------------------------------------------------------
-spec delete_chunk_on_node( binary(), atom()) -> ok.
delete_chunk_on_node(Key, Node) ->
  ok = rpc:call( Node, s3_chunk_client, delete, [Key]),
  io:format("File has been deleted, node: ~p, key: ~p ~n", [Node, Key]),
  ok.