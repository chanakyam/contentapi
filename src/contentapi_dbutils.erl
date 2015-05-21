-module(contentapi_dbutils).
-author("shree@ybrantdigital.com").
-include("config.hrl").

-export([
			maindb_url/0,
			textdb_url/0,
			videodb_url/0,
			channels/0,
			videos/0,
			sources/0,
			get_videos/4,
			get_widget/3,
			get_news/4,
			get_id_video/1,			
			get_id_text/1			
		]).

maindb_url() ->	
	?COUCHDB_ROOT ++ ?MAIN_DB
.

textdb_url() ->	
	?COUCHDB_ROOT ++ ?TEXT_DB
.

videodb_url() ->	
	?COUCHDB_ROOT ++ ?VIDEO_DB
.


channels() ->
	list_to_binary(?MODULE:maindb_url() ++ "channels")
.
videos() ->
	list_to_binary(?MODULE:maindb_url() ++ "videos")
.

sources() ->
	list_to_binary(?MODULE:maindb_url() ++ "sources")
.

get_news(Channel, Limit, Skip, NewsFormat) ->
	Url = case NewsFormat of 
			"short" ->				
				list_to_binary(?MODULE:textdb_url() ++ "_design/" ++ Channel ++ "/_view/by_id_title_desc_thumb_date?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true");													
													
			"long" ->
				list_to_binary(?MODULE:textdb_url() ++ "_design/" ++ Channel ++ "/_view/full_composite_article?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true")
																										
		end,
		 % io:format("non-video from contentapi_dbutils file Url is  ~s!", [Url]),
	Url
.

get_id_text(Id) ->
		Url = string:concat(?MODULE:textdb_url() , "/"),
		Url1 = string:concat(Url, Id),
       Url1
.

get_id_video(Id) ->
		Url = string:concat(?MODULE:videodb_url() , "/"),
		Url1 = string:concat(Url, Id),
       Url1
.

get_videos(Channel, Limit, Skip, NewsFormat) ->
	Url = case NewsFormat of 
			"short" ->				
				list_to_binary(?MODULE:videodb_url() ++ "_design/" ++ Channel ++ "/_view/by_id_title_desc_thumb_date?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true");													
													
			"long" ->
				list_to_binary(?MODULE:videodb_url() ++ "_design/" ++ Channel ++ "/_view/full_composite_article?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true")
																										
		end,
	Url
.
get_widget(Limit, Skip, NewsFormat) ->
	Url = case NewsFormat of 
			"short" ->				
				list_to_binary(?MODULE:videodb_url() ++ "_design/widget/_view/feed?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true");													
													
			"long" ->
				list_to_binary(?MODULE:videodb_url() ++ "_design/widget/_view/feed?limit=" ++ binary_to_list(Limit) ++ "&skip=" ++ binary_to_list(Skip) ++ "&format=" ++ NewsFormat ++ "&descending=true")
																										
		end,
	Url
.
