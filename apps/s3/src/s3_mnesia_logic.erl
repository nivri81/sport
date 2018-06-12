%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 30. May 2018 00:29
%%%-------------------------------------------------------------------
-module(s3_mnesia_logic).
-author("grzegorz").

-include_lib("stdlib/include/qlc.hrl").

%% API
-export([init/0, store_file_metadata/2, file_exists/1, read_key_node_list/1, delete_metadata/1]).

-record(file_metadata, {file_name :: binary(), key_node_list :: list() }).

%% -------------------------------------------------------------------
%% @doc init mnesia
%% -------------------------------------------------------------------
init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  try
    mnesia:table_info(type, file_metadata),
    mnesia:clear_table(file_metadata)
  catch
    exit: _ ->
      mnesia:create_table(file_metadata, [{attributes, record_info(fields, file_metadata)},
        {type,  bag},
        {disc_copies, [node()]}
      ])
  end.


%% -------------------------------------------------------------------
%% @doc check whether file already exists
%% -------------------------------------------------------------------
-spec file_exists( FileName :: binary()) -> boolean().
file_exists(FileName) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_metadata), X#file_metadata.file_name =:= FileName]),
    Results = qlc:e(Query),
    Results
  end,

  case mnesia:transaction(AF) of
    {atomic, []} -> false;
    {atomic, [_FileMetadata]} -> true
  end.

%% -------------------------------------------------------------------
%% @doc read metadata
%% -------------------------------------------------------------------
-spec read_key_node_list(FileName :: binary()) -> list().
read_key_node_list(FileName) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_metadata), X#file_metadata.file_name =:= FileName]),
    [Result] = qlc:e(Query),
    Result#file_metadata.key_node_list
       end,

  {atomic, KeyNodeList} = mnesia:transaction(AF),
  KeyNodeList.

%% -------------------------------------------------------------------
%% @doc store file metadata in mnesia
%% -------------------------------------------------------------------
-spec store_file_metadata(FileName :: binary(), ListOfChunksWithNodes :: list()) -> ok.
store_file_metadata(FileName, ListOfChunksWithNodes) ->
  KeyNodeList = [ {ChunkKey, CurrentNode} || { ChunkKey, CurrentNode, _ChunkData} <- ListOfChunksWithNodes ],
  AF = fun () ->
    mnesia:write(#file_metadata{ file_name = FileName, key_node_list =  KeyNodeList })
       end,
  {atomic, ok} = mnesia:transaction(AF),
  ok.

%% -------------------------------------------------------------------
%% @doc obliterate metadata for file in mnesia
%% -------------------------------------------------------------------
-spec delete_metadata( FileName :: binary()) -> ok.
delete_metadata(FileName) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_metadata), X#file_metadata.file_name =:= FileName]),
    Results = qlc:e(Query),
    F = fun() ->
        lists:foreach(fun(Result) -> mnesia:delete_object(Result) end, Results)
        end,
      mnesia:transaction(F)
     end,
  {atomic, {atomic, ok}} = mnesia:transaction(AF),
  ok.