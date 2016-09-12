#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname increment_allow_mult_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "standard", "counters", "test"]);
main([Server]) ->
	main([Server, "standard", "counters", "test"]);
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

	Vals = [binary_to_term(V) || V <- riakc_obj:get_values(Obj)],
	
	Val = case
		length(Vals)
	of
		0 -> 0;
		1 -> hd(Vals);
		_ -> resolve_siblings(Vals)
	end,

	Obj1a = riakc_obj:update_value(Obj, term_to_binary(Val + 1)),
	Obj1b = 
		case length(riakc_obj:get_metadatas(Obj))
	of
		0 -> Obj1a;
		%1 -> Obj1a;
		_ -> riakc_obj:update_metadata(Obj1a, hd(riakc_obj:get_metadatas(Obj)))
	end,

	{ok, Obj2} = riakc_pb_socket:put(Pid, Obj1b, [return_body]),
	[binary_to_term(V) || V <- (riakc_obj:get_values(Obj2))].

resolve_siblings(Vals) ->
	io:format("Found siblings: ~w, ", [Vals]),
	Max = lists:max(Vals),
	io:format("maximum value ~w, ", [Max]),
	Val = Max + length(Vals) - 1,
	io:format("resolving to ~w~n", [Val]),
	Val.
