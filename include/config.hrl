-author("shree@ybrantdigital.com").

-define(APP_VERSION, "0.1").
-define(SERVER_NAME, "Content API").
-define(APP_PORT, 80).
-define(APP_CONNECTORS, 100).
-define(MAX_CONNECTIONS, 2048).


-define(COUCHDB_ROOT, "http://localhost:5984/").
-define(VIDEO_DB, "contentapi_video/").
-define(TEXT_DB, "contentapi_text/").
-define(MAIN_DB, "contentapi/").
-define(GALLERY_DB, "contentapi_gallery").
-define(DB_POOLSIZE, 100).
-define(DB_POOLNAME, contentapipool).

-define(DEFAULT_NEWS_CHANNEL, <<"us_domestic">>).
-define(DEFAULT_NEWS_LIMIT, <<"10">>).
-define(DEFAULT_NEWS_SKIP, <<"0">>).
-define(DEFAULT_NEWS_FORMAT, <<"short">>).

-define(DEFAULT_VIDEOS_CHANNEL, <<"world_news">>).
-define(DEFAULT_VIDEOS_LIMIT, <<"10">>).
-define(DEFAULT_VIDEOS_SKIP, <<"0">>).
-define(DEFAULT_VIDEOS_FORMAT, <<"long">>).
