
-module(common_function_tests).
-author("merk").

-include_lib("eunit/include/eunit.hrl").


when__sample_of_data_is_less_chunks_size__test() ->
  Chunks = common_function:split(<<"123">>, 4),
  ?assertEqual(1, length(Chunks)).

when__sample_of_data_can_be_split__test() ->
  Chunks = common_function:split(<<"1234567">>, 4),
  ?assertEqual(3, length(Chunks)).

when__data_is_empty__test() ->
  Chunks = common_function:split(<<"">>, 4),
  ?assertEqual(0, length(Chunks)).