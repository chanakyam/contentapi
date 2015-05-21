-module(video_list_handler).
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
	%URL = "http://localhost",
	{QueryTuples, Req2} = cowboy_req:qs_vals(Req),

	% Get the Timestamp of Request
	StartTime = contentapi_utils:time_in_millis(), 
	
	%% Check for a valid channel in query string. If query string for channel found, return that value else default to us_news
	
	%% Get channel
	Channel = case proplists:is_defined(<<"channel">>,QueryTuples) of
		true ->
			%% Also check the validity of a channel
			proplists:get_value(<<"channel">>, QueryTuples);
		false ->
			?DEFAULT_VIDEOS_CHANNEL
	end,

	%% Get Limit
	Limit = case proplists:is_defined(<<"limit">>,QueryTuples) of
		true ->
			proplists:get_value(<<"limit">>, QueryTuples);
		false ->
			?DEFAULT_VIDEOS_LIMIT
	end,

	%% Get Skip
	Skip = case proplists:is_defined(<<"skip">>,QueryTuples) of
		true ->
			proplists:get_value(<<"skip">>, QueryTuples);
		false ->
			?DEFAULT_VIDEOS_SKIP
	end,

	%% Get Format
	Format = case proplists:is_defined(<<"format">>,QueryTuples) of
		true ->
			proplists:get_value(<<"format">>, QueryTuples);
		false ->
			?DEFAULT_VIDEOS_FORMAT
	end,
	
	%% Prepare the Desgin name to be queried
	ChannelDBView = "video_" ++ binary_to_list(Channel),

	%% Check for an optional format - long or short
	%% Long - Get all the article details
	%% Short - Id, title, thumb, date
	Url = case proplists:is_defined(<<"format">>, QueryTuples) of
		true ->
			contentapi_dbutils:get_videos(ChannelDBView, Limit, Skip, binary_to_list(proplists:get_value(<<"format">>, QueryTuples)));

		false ->
			contentapi_dbutils:get_videos(ChannelDBView, Limit, Skip, binary_to_list(?DEFAULT_VIDEOS_FORMAT))	
	end, 

	Url1 = binary_to_list(Url),

	{ok, "200", _, Response} = ibrowse:send_req(Url1,[],get,[],[]),
	Response1 = jsx:decode(list_to_binary(Response)),
	Rows = proplists:get_value(<<"rows">>, Response1),
	% Get the Timestamp before sending Response
	EndTime = contentapi_utils:time_in_millis(), 
	ResponseTime = (EndTime - StartTime)/1000000,

	Query = [[{<<"channel">>, Channel}, {<<"limit">>, Limit}, {<<"skip">>, Skip}, {<<"format">>, Format}, {<<"response_time">>, float_to_binary(ResponseTime, [{decimals, 6}, compact])}]],
	Articles = [ proplists:get_value(<<"value">>, X) || X <- Rows],
	ResponseBody=jsx:encode([{<<"query">>,Query}, {<<"articles">>, Articles}]),
	{ResponseBody, Req2, State}.
