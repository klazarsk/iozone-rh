## Record Rewrite

This test measures the performance of writing and re-writing a particular spot
within a file. This hot spot can have very interesting behaviors. If the size 
of the spot is small enough to fit in the CPU data cache then the performance is
very high. If the size of the spot is bigger than the CPU data cache but still 
fits in the TLB then one gets a different level of performance. If the size of 
the spot is larger than the CPU data cache and larger than the TLB but still 
fits in the operating system cache then one gets another level of performance, 
and if the size of the spot is bigger than the operating system cache then one
gets yet another level of performance. Some database formats may use this
method, as can the swap file or swap partition.

![Graph of writing and re-writing a specific point in a file](dirWorking/recrewrite/recrewrite.svg)

