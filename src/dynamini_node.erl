-module(dynamini_node).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start/0, start_link/0]).

-export([get/2, put/3]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(st, {
    data
}).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link(?MODULE, [], []).

start() ->
    gen_server:start(?MODULE, [], []).

get(Node, Key) ->
    gen_server:call(Node, {get, Key}).

put(Node, Key, Val) ->
    gen_server:call(Node, {put, Key, Val}).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([]) ->
    {ok, #st{data=dict:new()}}.

handle_call({get, Key}, _From, #st{data=Data}=St) ->
    Val = case dict:find(Key, Data) of
        {ok, Val0} ->
            Val0;
        error ->
            undefined
    end,
    {reply, Val, St};
handle_call({put, Key, Val}, _From, #st{data=Data0}=St) ->
    Data = dict:store(Key, Val, Data0),
    {reply, ok, St#st{data=Data}};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

