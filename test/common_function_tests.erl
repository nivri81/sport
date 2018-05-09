
-module(common_function_tests).
-author("merk").

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
  lager:debug("Running test"),
  Chunks = common_function:split(1,2),
  ?_assertEqual(3, length(Chunks)).
