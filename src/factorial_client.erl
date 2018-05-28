%%%-------------------------------------------------------------------
%%% @author merk
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. May 2018 16:13
%%%-------------------------------------------------------------------
-module(factorial_client).
-author("merk").

%% API
-export([factorial/1, factorialRecorder/2, storeComment/2, getComments/1, getCommentsWithStamp/1, deleteComment/1]).

factorial(Value) ->
  Result = factorial_server:factorial(Value),
  io:format("Factorial for ~p is ~p ~n", [Value, Result]).

factorialRecorder(Value, IoDevice) ->
  factorial_server:factorial(Value, IoDevice).

storeComment(NodeName, Comment) ->

  Result  = database_server:store(NodeName, Comment),

  case Result of
    {atomic, ok} -> io:format("Comment saved for ~p ~n", [NodeName]);
      _ -> io:format("Comment has not been saved for ~p, received ~p ~n", [NodeName, Result])
  end.

getComments(NodeName) ->
  database_server:getDB(NodeName).

getCommentsWithStamp(NodeName) ->
  Results = database_server:getDBTwo(NodeName),
  lists:foreach(fun({CM, CO}) -> io:format("Comment ~p  Created on ~p ~n", [CM, CO])end, Results).

deleteComment(NodeName) ->
  database_server:delete(NodeName).
