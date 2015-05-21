-module(contentapi_test).
-author("shree@ybrantdigital.com").

-export([fetch/1]).

fetch(Url) ->
	ibrowse:request(get, Url, [], <<>>, [])
.
	
