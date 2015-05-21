-module(contentapi_helpers).
-author("shree@ybrantdigital.com").

-export([server_date/0]).

server_date() ->
	Now = now(),
	{{YY, MM, DD}, {Hour, Min, Sec}} = calendar:now_to_universal_time(Now),
	{_,_,MicroSec} = Now,  
	list_to_binary(io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w.~p", [YY, MM, DD, Hour, Min, Sec, MicroSec]))
. 
