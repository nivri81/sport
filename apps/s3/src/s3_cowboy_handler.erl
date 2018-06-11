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

init(Req, State) ->
  {cowboy_rest, Req, State}.

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
  QueryString = cowboy_req:parse_qs(Req),
  {<<"filename">>, FileName} = lists:keyfind(<<"filename">>, 1, QueryString),
  FileData = s3_client:read(FileName),
  Body = jiffy:encode({[ {<<"filename">>, FileName}, {<<"data">>, FileData} ]}),
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

  {ok, Body, Req1} = cowboy_req:read_body(Req),
  {DecodedBody} = jiffy:decode(Body),
  {<<"filename">>, FileName} = lists:keyfind(<<"filename">>, 1, DecodedBody),
  {<<"data">>, Data} = lists:keyfind(<<"data">>, 1, DecodedBody),

  ok = s3_client:write(FileName, Data),
  Response = jiffy:encode({[{success, <<"File: '", FileName/binary,"' has been stored">>}]}),

  Req2 = cowboy_req:set_resp_body(Response, Req1),
  { true, Req2, State}.

%% -------------------------------------------------------------------
%% @doc Handler for delete method
%% -------------------------------------------------------------------
delete_resource(Req, State) ->

  {ok, Body, Req1} = cowboy_req:read_body(Req),
  {DecodedBody} = jiffy:decode(Body),
  {<<"filename">>, FileName} = lists:keyfind(<<"filename">>, 1, DecodedBody),

  ok = s3_client:delete(FileName),

  Response = jiffy:encode({[{success, <<"File: '", FileName/binary,"' has been deleted">>}]}),
  Req2 = cowboy_req:set_resp_body(Response, Req1),

  {true, Req2, State}.