-module(video_handler).
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
	io:format("Url is from video_handler ~p ~n", [URL]),

	Options = [{pool, contentapipool}],
	%{ok, StatusCode, RespHeaders, ClientRef} = ibrowse:request(Method-Atom, URL-binary, Headers-List, Paylod-Binary, Options-List of Tuples),
	Body = case ibrowse:request(get, URL, [], <<>>, Options) of
		{ok, 200, _, ClientRef} ->
			{ok, RespBody} = ibrowse:body(ClientRef),
			RespBody;
		{ok, 404, _, _} ->
			RespBody = jsx:encode(?ERROR1001),
			RespBody;
		{error, connect_timeout} ->
			RespBody = jsx:encode(?ERROR1002),
			RespBody
	end,
	
	{Body, Req, State}.
