#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname increment_default_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "default", "counters", "test"]);
main([Server, BType, Bucket, Key]) ->
	Val = operate(Server, BType, Bucket, Key),
	io:format("~w~n", [Val]).
	
operate(Server, BType, Bucket, Key) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),

	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	Obj = case
		riakc_pb_socket:get(Pid, {T, B}, K)
	of
		{ok, O} -> O;
		{error, notfound} -> riakc_obj:new({T, B}, K)
	end,

	Val = try
		binary_to_term(riakc_obj:get_value(Obj))
	catch
		no_value -> 0
	end,

	Obj1 = riakc_obj:update_value(Obj, term_to_binary(Val + 1)),
	{ok, Obj2} = riakc_pb_socket:put(Pid, Obj1, [return_body]),
	binary_to_term(riakc_obj:get_value(Obj2)).
