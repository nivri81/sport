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

%%====================================================================
%% API
%%====================================================================

write(FileName, Data) ->
  %% split to chunks - read chunk size from configuration
  %% read nodes from configuration
  %% send chunks to nodes (in parallel II iteration )
  %% store information {chunks name, node} in local mnesia table
  ok.

read(FileName) ->
  %% read chunks information from mnesia
  %% retrieve data from nodes (in parallel II iteration)
  %% sort chunks in right order
  ok.

delete(FileName) ->
  %% read chunks information from mnesia
  %% send request to remove all chunks (in parallel II iteration)
  %% remove record from mnesia
  ok.

%%====================================================================
%% Internal functions
%%====================================================================
