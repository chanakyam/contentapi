-module(contentapi_utils).
-author("shree@ybrantdigital.com").
-export([drop_id_rev/1, 
		 time_in_millis/0
		]).

drop_id_rev(RespBody) ->
	ResBody = jsx:decode(RespBody),
	Res1 = proplists:delete(<<"_id">>, ResBody),
	Res2 = proplists:delete(<<"_rev">>, Res1),
	jsx:encode(Res2)
.

time_in_millis() ->
	{MegaSecs, Secs, Microsecs} = erlang:now(),
	(MegaSecs*1000000 + Secs)*1000000 + Microsecs
.