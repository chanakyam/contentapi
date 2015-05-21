-module(id_text_handler).
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
	{Id, _ } = cowboy_req:qs_val(<<"id">>, Req),
	% Url = string:concat("http://contentapi.ws:5984/contentapi_text/", binary_to_list(Id)),
	Url = contentapi_dbutils:get_id_text(binary_to_list(Id)),	
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Body = list_to_binary(Response),
	{Body, Req, State}.

