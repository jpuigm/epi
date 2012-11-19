-module(epi_worker_tests).

-compile(export_all).

-include_lib("proper/include/proper.hrl").

prop_calculus() ->
    ?FORALL(I, nat(), epi_worker:calculus(I) =< I).

