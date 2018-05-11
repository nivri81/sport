-module(common_function).
-author("merk").

%% API
-export([split/1]).



%%====================================================================
%% API
%%====================================================================

%% ---------------------------------------
%% Split data into chunks
%% ---------------------------------------

-spec split(binary()) -> list().
split(Data) ->
  NumberOfElements = 4,
  List = binary_to_list(Data),
  split( List, ceil(length(List) / NumberOfElements)).

-spec split(list(), integer()) -> list().
split([],_) -> [];

split(List,Len) when Len > length(List) ->
  [List];

split(List,Len) ->
  {Head,Tail} = lists:split(Len,List),
  [Head | split(Tail,Len)].


%%====================================================================
%% Internal functions
%%====================================================================
