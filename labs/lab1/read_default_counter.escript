#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname read_default_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "default", "counters", "test"]);
main([Server]) ->
	main([Server, "default", "counters", "test"]);
main([Server, BType, Bucket, Key]) ->
	Val = operate(Server, BType, Bucket, Key),
	io:format("~w~n", [Val]).
	
operate(Server, BType, Bucket, Key) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),

	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	case
		riakc_pb_socket:get(Pid, {T, B}, K)
	of
		{ok, O} -> binary_to_term(riakc_obj:get_value(O));
		{error, notfound} -> notfound
	end.
