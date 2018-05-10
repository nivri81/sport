-module(file_server_client).
-author("merk").

%% API
-export([write_file/2, read_file/1, delete_file/1, start/0, stop/0]).

start()->
  server_s3:start_link().

stop()->
  server_s3:stop().

-spec write_file(binary(), binary()) -> ok | {error, _Reason}.
write_file(ChunkKey, Data) ->
  server_s3:write_chunk(ChunkKey, Data).

-spec read_file(binary()) -> binary().
read_file(ChunkKey) ->
  server_s3:read_chunk(ChunkKey).

-spec delete_file(binary()) -> ok | {error, _Reason}.
delete_file(ChunkKey) ->
  server_s3:delete_chunk(ChunkKey).

