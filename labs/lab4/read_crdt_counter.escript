#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname read_crtd_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "counters", "test", "test"]);
main([Server]) ->
	main([Server, "counters", "test", "test"]);
main([Server, BType, Bucket, Key]) ->
	Val = operate(Server, BType, Bucket, Key),
	io:format("~w~n", [Val]).
	
operate(Server, BType, Bucket, Key) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),
	
	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	case
		riakc_pb_socket:fetch_type(Pid, {T, B}, K)
	of
		{ok, O} -> riakc_counter:value(O);
		{error, {notfound,counter}} -> notfound
	end.
