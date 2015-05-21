-module(site_root_handler).
-author("shree@ybrantdigital.com").
-include("config.hrl").

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
	ServerName = ?SERVER_NAME,
	
	ServerDate = contentapi_helpers:server_date(),
	AppVersion = ?APP_VERSION,
	Body = jsx:encode([
						{<<"server">>, list_to_binary(ServerName)},
					  	{<<"version">>, list_to_binary(AppVersion)},
					  	{<<"server_date">>, ServerDate}
					 ]),
	{Body, Req, State}.
