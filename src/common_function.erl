-module(common_function).
-author("merk").

%% API
-export([split/1]).

-define(NUMBER_OF_CHUNKS, application:get_env(sport, number_of_chunks)).

%% ---------------------------------------
%% Split data into chunks
%% ---------------------------------------

split(Data) ->
  io:format("------- ~p", [application:get_all_env(sport)]),
  NumberOfElements = ?NUMBER_OF_CHUNKS,
  split(Data, NumberOfElements).


split(Data, NumberOfElements) ->
  [Data, NumberOfElements].