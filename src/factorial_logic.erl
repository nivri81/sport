%%%-------------------------------------------------------------------
%%% @author merk
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 16:12
%%%-------------------------------------------------------------------
-module(factorial_logic).
-author("merk").

%% API
-export([factorial/2, factorial/3, factorial_handler/0]).


%% -------------------------------------------------------------------
factorial(0, Acc) ->
  Acc;
factorial(Int, Acc) when Int > 0 ->
  factorial(Int - 1, Acc * Int).

%% -------------------------------------------------------------------

factorial(0, Acc, IoDevice) ->
  io:format(IoDevice, "Factorial results: ~p ~n ", [Acc]);

factorial(Int, Acc, IoDevice) when Int > 0 ->
  io:format(IoDevice, "Current factorial Log: ~p ~n", [Acc]),
  factorial(Int - 1, Acc * Int, IoDevice ).

%% -------------------------------------------------------------------

factorial_handler() ->
  receive
    {factorial, Int} ->
      io:format("Factorial for ~p is ~p ~n", [Int, factorial(Int, 1)]),
      factorial_handler();

    {factorialRecoredr, Int, File} ->
      {ok, IoDevice} = file:open(File, write),
      factorial(Int, 1, IoDevice),
      io:format("Factorial recoredr done ~n"),
      file:close(IoDevice),
      factorial_handler();
    Other ->
      io:format("Invalid Match for ~p ~n", [Other]),
      factorial_handler()
  end.