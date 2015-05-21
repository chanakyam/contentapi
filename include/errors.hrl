-author("shree@ybrantdigital.com").

% General Site Errors
-define(ERROR1001, [{<<"status">>, <<"error">>},{<<"code">>, <<"1001">>}, {<<"reason">>, <<"requested resource not found">>}]).
-define(ERROR1002, [{<<"status">>, <<"error">>},{<<"code">>, <<"1002">>}, {<<"reason">>, <<"fatal error">>},{<<"hint">>, <<"Run Diagnostics">>} ]).

% Database Errors
-define(ERROR2000, [{<<"status">>, <<"success">>},{<<"code">>, <<"2000">>}, {<<"reason">>, <<"Database Connection succeeded">>} ]).
-define(ERROR2001, [{<<"status">>, <<"error">>},{<<"code">>, <<"2001">>}, {<<"reason">>, <<"Database Connection failed">>},{<<"hint">>, <<"Please contact Administrator">>} ]).

-define(VALID_CHANNEL_MESSAGE_IF_EMPTY, [{<<"status">>, <<"error">>}, {<<"hint">>, <<"Please supply a valid channel">>}]).
-define(VALID_CHANNEL, [{<<"channel">>, Channel}, {<<"status">>, <<"valid">>}]).
-define(INVALID_CHANNEL, [{<<"channel">>, Channel}, {<<"status">>, <<"invalid">>}]).