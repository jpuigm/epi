TODO
===

* Spawning or waiting has to be done by another process, otherwise the waiting is behing held.
* Work out the deviation from the real pi number.
* Add timing stats (spawn + calculations)
* Integrate lager.
* Add events logging. Need to confirm why it slows down in the beginning and it the end.
* Log when EXIT signal is received by master process.
* Replace spawn_link with dynamic children addition and termination.
* Include eUnit testing.
* Tests per worker must be divisible by N. Need to assign the remaining if not multiple.