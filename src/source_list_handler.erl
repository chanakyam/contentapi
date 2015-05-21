-module(source_list_handler).
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
	URL = contentapi_dbutils:sources(),	
	Url1 = binary_to_list(URL),
	{ok, "200", _, Response} = ibrowse:send_req(Url1,[],get,[],[]),
	Body = list_to_binary(Response),
	{Body, Req, State}.
