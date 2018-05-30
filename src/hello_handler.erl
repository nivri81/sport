%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 30. May 2018 21:39
%%%-------------------------------------------------------------------
-module(hello_handler).
-author("grzegorz").

%% API
-export([init/2]).


init(Req0, State) ->
  io:format("~n ------------------------------- ~n"),
  Req = cowboy_req:reply(200,
    #{<<"content-type">> => <<"text/plain">>},
    <<"Hello Erlang!">>,
    Req0),
  {ok, Req, State}.