%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 19:48
%%%-------------------------------------------------------------------
-module(s3_chunk_logic).
-author("grzegorz").

-include_lib("stdlib/include/qlc.hrl").

%% API
-export([init/0, write/2, read/1, delete/1]).

-record(file_chunk, {key, data, createdOn}).

%% -------------------------------------------------------------------
%% @doc init chunk
%% -------------------------------------------------------------------
-spec init() -> ok.
init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  try
      mnesia:table_info(type, file_chunk),
      mnesia:clear_table(file_chunk)
  catch
      exit: _ ->
        mnesia:create_table(file_chunk, [{attributes, record_info(fields, file_chunk)},
        {type,  bag},
        {disc_copies, [node()]}
        ])
  end,

  ok.

%% -------------------------------------------------------------------
%% @doc write chunk
%% -------------------------------------------------------------------
-spec write(Key :: binary(), Data :: binary()) -> ok.
write(Key, Data) ->
  io:format("Chunk write key ~p ~n", [Key]),
  AF = fun () ->
    {CreatedOn, _} = calendar:universal_time(),
    mnesia:write(#file_chunk{ key = Key, data = Data, createdOn = CreatedOn })
    end,
  {atomic, ok} = mnesia:transaction(AF),
  ok.

%% -------------------------------------------------------------------
%% @doc read chunk
%% -------------------------------------------------------------------
-spec read(Key :: binary()) -> binary().
read(Key) ->
  io:format("Chunk read key ~p ~n", [Key]),
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_chunk), X#file_chunk.key =:= Key]),
    [Result] = qlc:e(Query),
    Result#file_chunk.data
  end,
  {atomic, FileContent} = mnesia:transaction(AF),
  FileContent.

%% -------------------------------------------------------------------
%% @doc delete chunk
%% -------------------------------------------------------------------
-spec delete(Key :: binary()) -> ok.
delete(Key) ->
  io:format("Chunk delete key: ~p ~n", [Key]),
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_chunk), X#file_chunk.key =:= Key]),
    Results = qlc:e(Query),
    F = fun() ->
        lists:foreach(fun(Result) -> mnesia:delete_object(Result) end, Results)
      end,
    mnesia:transaction(F)
   end,
  {atomic,{atomic,ok}} = mnesia:transaction(AF),
  ok.
