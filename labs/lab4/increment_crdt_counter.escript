#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname increment_crdt_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "counters", "test", "test", "1"]);
main([Server, Amount]) ->
	main([Server, "counters", "test", "test", Amount]);
main([Server, BType, Bucket, Key]) ->
	main([Server, BType, Bucket, Key, "1"]);
main([Server, BType, Bucket, Key, Amount]) ->
	Val = operate(Server, BType, Bucket, Key, Amount),
	io:format("~w~n", [Val]).
	
operate(Server, BType, Bucket, Key, Amount) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),
	A = list_to_integer(Amount),
	
	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	Counter = case
		riakc_pb_socket:fetch_type(Pid, {T, B}, K)
	of
		{ok, O} -> O;
		{error, {notfound,counter}} -> riakc_counter:new()
	end,

	Counter1 = riakc_counter:increment(A, Counter),
	
	{ok, {counter, Val, _}} = riakc_pb_socket:update_type(
		Pid, {T, B}, K, riakc_counter:to_op(Counter1), [return_body]),
	Val.