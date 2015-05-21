-module(contentapi_app).

-behaviour(application).

-include("config.hrl").
%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile(routes()), 

	TransOpts = [{port, ?APP_PORT},{max_connections, ?MAX_CONNECTIONS}],
    ProtoOpts = [{env, [{dispatch, Dispatch}]},
    				{onrequest, fun request_hook_responder:set_cors/1},
                    {onresponse, fun error_hook_responder:respond/4}
    			],    

	{ok, _}   = cowboy:start_http(http, ?APP_CONNECTORS, TransOpts, ProtoOpts),
    contentapi_sup:start_link().

stop(_State) ->
    ok.

routes() ->
	[
		{'_',[
                {"/", site_root_handler, []},
                {"/channels", channel_list_handler, []},
                {"/diagnostics", diagnostics_handler, []},
                {"/sources", source_list_handler, []},
                {"/videos", video_list_handler, []},
                {"/widget", widget_list_handler, []},
                %/news?channel=us_news&limit=10&skip=0
                {"/news", news_handler, []},
                {"/t", id_text_handler, []},
                {"/v", id_video_handler, []},
                %/valid?channel=us_news
                {"/valid", validity_handler, []},
                %/video?channel=us_news&limit=10&skip=0
                {"/video", video_handler, []}                
        ]}		
	]
.