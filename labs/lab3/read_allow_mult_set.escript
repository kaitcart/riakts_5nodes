#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname increment_allow_mult_counter -mnesia debug verbose

main([]) ->
	main(["127.0.0.1", "standard", "sets", "test"]);
main([Server]) ->
	main([Server, "standard", "sets", "test"]);
main([Server, BType, Bucket, Key]) ->
	Res = operate(Server, BType, Bucket, Key),
	io:format("Result:~n"),
	[io:format("~p~n", [ordsets:to_list(Set)]) || Set <- Res].
	
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
	
	case
		length(Vals)
	of
		0 -> notfound;
		1 -> Vals;
		_ -> [resolve_siblings(Vals)]
	end.

resolve_siblings(Vals) ->
	io:format("Found siblings:~n"),
	[io:format("~p,~n", [ordsets:to_list(Val)]) || Val <- Vals],
	Res = ordsets:union(Vals),
	io:format("Resolving to:~n"),
	[io:format("~p~n", [ordsets:to_list(Res)])],
	Res.