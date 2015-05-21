-module(channel_list_handler).
-author("shree@ybrantdigital.com").
-include("config.hrl").
-include("errors.hrl").

-export([init/3]).

-export([content_types_provided/2]).
-export([index/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"application/json">>, index}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
index(Req, State) ->
	URL = contentapi_dbutils:channels(),
	% Options = [{pool, contentapipool}],
	%{ok, StatusCode, RespHeaders, ClientRef} = ibrowse:request(Method-Atom, URL-binary, Headers-List, Paylod-Binary, Options-List of Tuples),
	Url1 = binary_to_list(URL),
	{ok, "200", _, Response1} = ibrowse:send_req(Url1,[],get,[],[]),
	Response = jsx:decode(list_to_binary(Response1)),
	Reuters = proplists:get_value(<<"reuters">>, Response),
	Covermag = proplists:get_value(<<"covermag">>, Response),
	Videos = proplists:get_value(<<"videos">>, Response),
	ResponseBody=jsx:encode([{<<"reuters">>,Reuters}, {<<"covermag">>, Covermag},{<<"videos">>, Videos}]),
	{ResponseBody, Req, State}.
