#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname increment_allow_mult_counter -mnesia debug verbose

main([Val]) ->
	main(["127.0.0.1", "standard", "sets", "test", Val]);
main([Server]) ->
	main([Server, "standard", "sets", "test"]);
main([Server, BType, Bucket, Key, Val]) ->
	Res = operate(Server, BType, Bucket, Key, Val),
	io:format("Current server status:~n"),
	[io:format("~p~n", [ordsets:to_list(Set)]) || Set <- Res].
	
operate(Server, BType, Bucket, Key, Val) ->
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
	
	Set = case
		length(Vals)
	of
		0 -> ordsets:new();
		1 -> hd(Vals);
		_ -> resolve_siblings(Vals)
	end,

	Obj1a = riakc_obj:update_value(Obj, term_to_binary(ordsets:add_element(Val, Set))),
	Obj1b = 
		case length(riakc_obj:get_metadatas(Obj))
	of
		0 -> Obj1a;
		_ -> riakc_obj:update_metadata(Obj1a, hd(riakc_obj:get_metadatas(Obj)))
	end,

	{ok, Obj2} = riakc_pb_socket:put(Pid, Obj1b, [return_body]),
	[binary_to_term(V) || V <- (riakc_obj:get_values(Obj2))].

resolve_siblings(Vals) ->
	io:format("Found siblings:~n"),
	[io:format("~p,~n", [ordsets:to_list(Val)]) || Val <- Vals],
	Res = ordsets:union(Vals),
	io:format("Resolving to:~n"),
	[io:format("~p~n", [ordsets:to_list(Res)])],
	Res.