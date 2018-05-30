%%%-------------------------------------------------------------------
%%% @author merk
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 16:13
%%%-------------------------------------------------------------------
-module(storage_chunk_client).
-author("merk").

%% API
-export([write/2, read/1, delete/1]).

write(Key, Data) ->
  Result  = storage_chunk_server:write(Key, Data),
  case Result of
    {atomic, ok} -> io:format("Data saved for ~p ~n", [Key]);
      _ -> io:format("Data has not been saved for ~p, received ~p ~n", [Key, Result])
  end.

read(Key) ->
  storage_chunk_server:read(Key).

delete(Key) ->
  storage_chunk_server:delete(Key).
