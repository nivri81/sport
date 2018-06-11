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

-export([allowed_methods/2, content_types_provided/2, content_types_accepted/2, delete_resource/2]).

-export([read_file/2, write_file/2]).



init(Req, Opts) ->
  io:format(user, "init ~p ", [ z ]),
  {cowboy_rest, Req, Opts}.


allowed_methods(Req, State) ->
  {[<<"GET">>, <<"DELETE">>, <<"PUT">>], Req, State}.



%% -------------------------------------------------------------------
%% @doc Handler for get method
%% -------------------------------------------------------------------
content_types_provided(Req, State) ->
  io:format(user, "content type accepted ~p ", [ z ]),
  {[
    {{<<"application">>, <<"json">>, []}, read_file}
  ], Req, State}.


read_file(Req, State) ->

  Method = cowboy_req:method(Req),

%%  FileName = cowboy_req:binding(file_name, Req),
  io:format(user, "Method ~p ", [Method ]),

  Body = <<"{\"rest\": \"Hello World from get!\"}">>,
  { Body , Req, State}.


%% -------------------------------------------------------------------
%% @doc Handler for put method
%% -------------------------------------------------------------------
content_types_accepted(Req, State) ->
  io:format(user, "content type accepted ~p ", [ z ]),
  {[
    {{<<"application">>, <<"json">>, []}, write_file}
  ], Req, State}.

write_file(Req, State) ->

  Method = cowboy_req:method(Req),

  io:format(user, "Method ~p ", [Method ]),
  Body = <<"{\"rest\": \"Hello World from put!\"}">>,
  Req1 = cowboy_req:set_resp_body(Body, Req),
  { true, Req1, State}.

%% -------------------------------------------------------------------
%% @doc Handler for delete method
%% -------------------------------------------------------------------
delete_resource(Req, State) ->
  

  Body = <<"{\"rest\": \"Hello World from delete!\"}">>,
  Req1 = cowboy_req:set_resp_body(Body, Req),

  {true, Req1, State}.