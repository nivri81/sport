%%%-------------------------------------------------------------------
%%% @author grzegorz
%%% @copyright (C) 2018, The Company Ltd
%%% @doc
%%%
%%% @end
%%% Created : 12. Jun 2018 22:21
%%%-------------------------------------------------------------------
-module(s3_rest_test).
-author("grzegorz").

-include_lib("eunit/include/eunit.hrl").

%% API
-export([]).

%% -------------------------------------------------------------------
%% @doc Tests
%% -------------------------------------------------------------------

when_deleting_not_existing_file_then_failure_test() ->
  {StatusCode, Body} = delete_file(),
  ?assertEqual (500, StatusCode),
  ?assertEqual("{\"failure\":\"Error occurred while removing file: 'foobar.txt'\"}", Body).

when_deleting_existing_file_then_succeed_test() ->
  delete_file(),
  create_file(),
  {StatusCode, Body} = delete_file(),
  ?assertEqual (200, StatusCode),
  ?assertEqual("{\"success\":\"File: 'foobar.txt' has been deleted\"}", Body).

when_create_not_existing_file_then_succeed_test() ->
  delete_file(),
  {StatusCode, Body} = create_file(),
  delete_file(),
  ?assertEqual(200, StatusCode),
  ?assertEqual("{\"success\":\"File: 'foobar.txt' has been stored\"}", Body).

when_overwrite_existing_file_then_failure_test() ->
  delete_file(),
  create_file(),
  {StatusCode, Body} = create_file(),
  delete_file(),
  ?assertEqual(400, StatusCode),
  ?assertEqual("{\"failure\":\"Error occurred while storing file: 'foobar.txt'\"}", Body).

when_reading_existing_file_then_succeed_test() ->
  delete_file(),
  create_file(),
  {StatusCode, Body} = read_file(),
  delete_file(),
  ?assertEqual(200, StatusCode),
  ?assertEqual("{\"filename\":\"foobar.txt\",\"data\":\"file data\"}", Body).

when_reading_not_existing_file_then_failure_test() ->
  delete_file(),
  {StatusCode, Body} = read_file(),
  delete_file(),
  ?assertEqual(400, StatusCode),
  ?assertEqual("{\"failure\":\"Error occurred while reading file: 'foobar.txt'\"}", Body).

%% -------------------------------------------------------------------
%% @doc Helper method
%% -------------------------------------------------------------------

read_file() ->
  {ok, {{_Version, StatusCode, _ReasonPhrase}, _Headers, Body}} =
    httpc:request(get, {"http://localhost:8080/file?filename=foobar.txt", []}, [], []),
  {StatusCode, Body}.

create_file() ->
  {ok, {{_Version, StatusCode, _ReasonPhrase}, _Headers, Body}} =
    httpc:request(put, {"http://localhost:8080/file", [], "application/json", "{ \"filename\": \"foobar.txt\", \"data\": \"file data\"}"}, [], []),
  {StatusCode, Body}.

delete_file() ->
  {ok, {{_Version, StatusCode, _ReasonPhrase}, _Headers, Body}} =
    httpc:request(delete, {"http://localhost:8080/file", [], "application/json", "{\"filename\": \"foobar.txt\"}"}, [], []),
  {StatusCode, Body}.