epi
===

Pi number calculation

examples
========

$ erl -pa ebin/
Erlang R15B02 (erts-5.9.2) [source] [64-bit] [smp:4:4] [async-threads:0] [hipe] [kernel-poll:false]

Eshell V5.9.2  (abort with ^G)
1> application:start(epi).
ok
2> epi_master:pi(1000000000,10000).
10000 workers successfully spawned
3.14160173199999981364e+00
ok
3> epi_master:pi(10000000000,10000).
10000 workers successfully spawned
3.14160417320000018293e+00
ok
4> epi_master:pi(100000000,10).
10 workers successfully spawned
3.14151040000000003616e+00
ok



Ref: http://bob.ippoli.to/archives/2007/12/17/printing-floats-with-erlang/

errors:

10> epi_master:pi(1000000000,100000).

=ERROR REPORT==== 22-Jan-2013::12:00:20 ===
Too many processes


=ERROR REPORT==== 22-Jan-2013::12:00:55 ===
** Generic server epi_master terminating
** Last message in was {pi,1000000000,100000}
** When Server state == {state,0,0}
** Reason for termination ==
** {system_limit,[{erlang,spawn_link,
                          [epi_worker,calculus,[10000,<0.38.0>]],
                          []},
                  {epi_master,start_workers,3,
                              [{file,"src/epi_master.erl"},{line,79}]},
                  {epi_master,handle_call,3,
                              [{file,"src/epi_master.erl"},{line,48}]},
                  {gen_server,handle_msg,5,
                              [{file,"gen_server.erl"},{line,588}]},
                  {proc_lib,init_p_do_apply,3,
                            [{file,"proc_lib.erl"},{line,227}]}]}

