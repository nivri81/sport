
-module(common_function_tests).
-author("merk").

-include_lib("eunit/include/eunit.hrl").


when__sample_of_data_is_less_than_number_of_chunks__test() ->
  Chunks = common_function:split_binary(<<"123">>, 4),
  ?assertEqual(1, length(Chunks)).


when__sample_of_data_is_to_small__test() ->
  Chunks = common_function:split_binary(<<"123456">>, 4),
  ?assertEqual(2, length(Chunks)).


when__sample_of_data_can_be_split__test() ->
  Chunks = common_function:split_binary(<<"123456789112">>, 4),
  ?assertEqual(3, length(Chunks)).

when__data_is_empty__test() ->
  Chunks = common_function:split_binary(<<"">>, 4),
  ?assertEqual(0, length(Chunks)).