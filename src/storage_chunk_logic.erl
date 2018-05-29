%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 19:48
%%%-------------------------------------------------------------------
-module(storage_chunk_logic).
-author("grzegorz").

-include_lib("stdlib/include/qlc.hrl").

%% API
-export([init/0, write/2, read/1, delete/1]).

-record(file_chunk, {key, data, createdOn}).

init() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  try
      mnesia:table_info(type, file_chunk)
  catch
      exit: _ ->
        mnesia:create_table(file_chunk, [{attributes, record_info(fields, file_chunk)},
        {type,  bag},
        {disc_copies, [node()]}
        ])
  end.


write(Key, Data) ->
  AF = fun () ->
    {CreatedOn, _} = calendar:universal_time(),
    mnesia:write(#file_chunk{ key = Key, data = Data, createdOn = CreatedOn })
    end,
  mnesia:transaction(AF).

read(Key) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_chunk), X#file_chunk.key =:= Key]),
    Results = qlc:e(Query),
    lists:map(fun(Item) -> Item#file_chunk.data end, Results)
  end,
  {atomic, Comments} = mnesia:transaction(AF),
  Comments.

delete(Key) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(file_chunk), X#file_chunk.key =:= Key]),
    Results = qlc:e(Query),
    F = fun() ->
        lists:foreach(fun(Result) -> mnesia:delete_object(Result) end, Results)
      end,
    mnesia:transaction(F)
   end,
  mnesia:transaction(AF).
