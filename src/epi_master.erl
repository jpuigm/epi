%%%-------------------------------------------------------------------
%%% @author Juan Puig <jpuig@brocade.com>
%%% @copyright (C) 2012, Juan Puig
%%% @doc
%%% Master process that reads N and P values. Responsible to create P 
%%% workers and order N experiments across them.
%%% @end
%%% Created : 15 Nov 2012 by Juan Puig <jpuig@brocade.com>
%%%-------------------------------------------------------------------
-module(epi_master).

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([pi/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {workers,
                experiments}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

pi(N, P) ->
    gen_server:call(?MODULE, {pi, N, P}, infinity).
    

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, #state{workers = 0,
                experiments = 0}}.

handle_call({pi, N, P}, _From, State) ->
    {ok, Pids} = start_workers(P, N div P, []),
    {ok, C} = wait_for_results(Pids, 0),
    Reply = {pi, 4*C/N},
    {reply, Reply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

start_workers(0, _, Pids) ->
    {ok, Pids};
start_workers(1, Np, Pids) ->
    start_workers(0, Np, [spawn_link(epi_worker, calculus, [Np, self(), [verbose, {total, Np}]])|Pids]);
start_workers(P, Np, Pids) ->
    start_workers(P-1, Np, [spawn_link(epi_worker, calculus, [Np, self()])|Pids]).

wait_for_results([], Acc) ->
    {ok, Acc};
wait_for_results(Pids, Acc) ->
    receive
        {ok, {Pid, Val}} ->
            %% io:format("Received from ~p, c=~p~n ", [Pid, Val]),
            %% NoPids = length(Pids),
            %% case NoPids rem 100 of
            %%     0 -> io:format("Processes alive: ~p~n", [NoPids]);
            %%     _ -> ok
            %% end,                         
            wait_for_results(lists:delete(Pid, Pids), Acc + Val)
    end.
