-module(common_function).
-author("merk").

%% API
-export([split_binary/2]).

%%====================================================================
%% API
%%====================================================================

%% ---------------------------------------
%% Split data into chunks
%% ---------------------------------------


-spec split_binary(binary(), integer()) -> list().
split_binary(Data, Length) ->
  split( binary_to_list(Data), Length).


-spec split(list(), integer()) -> list().
split([], _) -> [];

split(List, Length) when Length > length(List) ->
  [List];

split(List, Length) ->
  {Head, Tail} = lists:split(Length, List),
  [Head | split(Tail, Length)].


%%====================================================================
%% Internal functions
%%====================================================================
