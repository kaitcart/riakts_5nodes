#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname remove_from_crdt_set -mnesia debug verbose

main([Val]) ->
	main(["127.0.0.1", "sets", "test", "test", Val]);
main([Server, Val]) ->
	main([Server, "sets", "test", "test", Val]);
main([Server, BType, Bucket, Key, Val]) ->
	Res = operate(Server, BType, Bucket, Key, Val),
	io:format("~p~n", [Res]).
	
operate(Server, BType, Bucket, Key, Val) ->
	T = unicode:characters_to_binary(BType),
	B = unicode:characters_to_binary(Bucket),
	K = unicode:characters_to_binary(Key),
	
	{ok, Pid} = riakc_pb_socket:start_link(Server, 8087),

	Set = case
		riakc_pb_socket:fetch_type(Pid, {T, B}, K)
	of
		{ok, O} -> O;
		{error, {notfound, set}} -> riakc_set:new()
	end,

	Set1 = riakc_set:del_element(unicode:characters_to_binary(Val), Set),
	
	{ok, {set, Vals, _Adds, _Dels, _Ctx}} = riakc_pb_socket:update_type(
		Pid, {T, B}, K, riakc_set:to_op(Set1), [return_body]),
	Vals.
