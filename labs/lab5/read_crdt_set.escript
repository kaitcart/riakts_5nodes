#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname read_crdt_set -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "sets", "test", "test"]);
main([Server]) ->
	main([Server, "sets", "test", "test"]);
main([Server, BType, Bucket, Key]) ->
	Res = operate(Server, BType, Bucket, Key),
	io:format("~p~n", [Res]).
	
operate(Server, BType, Bucket, Key) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),
	
	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	case
		riakc_pb_socket:fetch_type(Pid, {T, B}, K)
	of
		{ok, O} -> riakc_set:value(O);
		{error, {notfound, set}} -> notfound
	end.
