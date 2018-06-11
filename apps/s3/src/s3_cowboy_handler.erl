%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 30. May 2018 21:39
%%%-------------------------------------------------------------------
-module(s3_cowboy_handler).
-author("grzegorz").

%% API
-export([init/2]).

-export([allowed_methods/2, content_types_provided/2]).

-export([handle/2]).


%%-record(state, {operation, response}).

init(Req, Opts) ->
  io:format(user, "init ~p ", [ z ]),
%%  [{op, Operation} | _] = Opts,
%%  State = #state{operation = Operation, response=none},
  {cowboy_rest, Req, Opts}.


allowed_methods(Req, State) ->
  {[<<"GET">>, <<"DELETE">>, <<"PUT">>], Req, State}.

content_types_provided(Req, State) ->
  io:format(user, "content type accepted ~p ", [ z ]),
  {[
    {{<<"application">>, <<"json">>, []}, handle}
  ], Req, State}.



handle(Req, State) ->

  Method = cowboy_req:method(Req),

%%  FileName = cowboy_req:binding(file_name, Req),
  io:format(user, "Method ~p ", [Method ]),
  {"Some Dody", Req, State}.