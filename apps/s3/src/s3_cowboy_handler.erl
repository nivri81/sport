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
  {[
    {{<<"application">>, <<"json">>, []}, read_file}
  ], Req, State}.

read_file(Req, State) ->
  QueryString = cowboy_req:parse_qs(Req),
  FileName = proplists:get_value(<<"filename">>, QueryString),

  try
    FileData = s3_client:read(FileName),
    Body = jiffy:encode({[ {<<"filename">>, FileName}, {<<"data">>, FileData} ]}),
    { Body , Req, State}
  catch
    _: _ ->
      ErrorResponse = jiffy:encode({[{ failure, <<"Error occurred while reading file: '", FileName/binary,"'">>}]}),
      ReqError = cowboy_req:set_resp_body(ErrorResponse, Req),
       ReqError1 = cowboy_req:reply(400, ReqError),
      {halt, ReqError1, State}
  end.

%% -------------------------------------------------------------------
%% @doc Handler for put method
%% -------------------------------------------------------------------
content_types_accepted(Req, State) ->
  {[
    {{<<"application">>, <<"json">>, []}, write_file}
  ], Req, State}.

write_file(Req, State) ->

  {ok, Body, Req1} = cowboy_req:read_body(Req),
  {DecodedBody} = jiffy:decode(Body),

  FileName = proplists:get_value(<<"filename">>, DecodedBody),
  Data = proplists:get_value(<<"data">>, DecodedBody),

  try
    ok = s3_client:write(FileName, Data),
    SuccessResponse = jiffy:encode({[{success, <<"File: '", FileName/binary,"' has been stored">>}]}),
    Req2 = cowboy_req:set_resp_body(SuccessResponse, Req1),
    { true, Req2, State}
  catch
    _: _ ->
      ErrorResponse = jiffy:encode({[{ failure, <<"Error occurred while storing file: '", FileName/binary,"'">>}]}),
      ReqError = cowboy_req:set_resp_body(ErrorResponse, Req1),
      {false, ReqError, State}
  end.

%% -------------------------------------------------------------------
%% @doc Handler for delete method
%% -------------------------------------------------------------------
delete_resource(Req, State) ->

  {ok, Body, Req1} = cowboy_req:read_body(Req),
  {DecodedBody} = jiffy:decode(Body),

  FileName = proplists:get_value(<<"filename">>, DecodedBody),

  try
    ok = s3_client:delete(FileName),
    Response = jiffy:encode({[{success, <<"File: '", FileName/binary,"' has been deleted">>}]}),
    Req2 = cowboy_req:set_resp_body(Response, Req1),
    {true, Req2, State}
  catch
    _: _ ->
      ErrorResponse = jiffy:encode({[{ failure, <<"Error occurred while removing file: '", FileName/binary,"'">>}]}),
      ReqError = cowboy_req:set_resp_body(ErrorResponse, Req1),
      {false, ReqError, State}
  end.
