-module(validity_handler).
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

%% API call for external clients to check validity of a channel, source and any other resource
index(Req, State) ->
	
	{QueryTuples, Req2} = cowboy_req:qs_vals(Req),
	Channel = case proplists:is_defined(<<"channel">>,QueryTuples) of
		true ->
			proplists:get_value(<<"channel">>, QueryTuples);
		false ->
			nochannel
		
	end,

	Body = case is_atom(Channel) of
		true ->
			jsx:encode(?VALID_CHANNEL_MESSAGE_IF_EMPTY);
		false ->
			success_response(Channel)
	end,
	{Body, Req2, State}.


%% Internal Calls
success_response(Channel) ->
	Url = contentapi_dbutils:channels(),
	URL = binary_to_list(Url),
	io:format("url is ~p ~n", [URL]),
	% Options = [{pool, contentapipool}],
	%{ok, StatusCode, RespHeaders, ClientRef} = hackney:request(Method-Atom, URL-binary, Headers-List, Paylod-Binary, Options-List of Tuples),
	Body = case ibrowse:send_req(URL,[],get,[],[]) of
		{ok, "200", _, Response} ->
			Res = string:sub_string(Response, 1, string:len(Response) -1 ),
			RespBody1 = list_to_binary(Res),		
			ResBody = verify_channel_validity(Channel, RespBody1),
			ResBody;
		{ok, "404", _, _} ->
			RespBody = jsx:encode(?ERROR1001),
			RespBody;
		{error, connect_timeout} ->
			RespBody = jsx:encode(?ERROR1002),
			RespBody
	end,
	Body
.
verify_channel_validity(Channel, RespBody) ->
	%% Return a valid JSON for valid and invalid channels
	Channels = proplists:get_value(<<"reuters">>, jsx:decode(RespBody)),

	RBody = case lists:member(Channel, Channels) of
		true ->
			jsx:encode(?VALID_CHANNEL);
		false ->
			jsx:encode(?INVALID_CHANNEL)
	end,
	RBody
.
