## Fread:

This test measures the performance of reading a file using the library function
fread(). This is a library routine that performs buffered & blocked read 
operations. The buffer is within the user’s address space. If an application 
were to read in very small size transfers then the buffered & blocked I/O 
functionality of fread() can enhance the performance of the application by 
reducing the number of actual operating system calls and increasing the size of
the transfers when operating system calls are made.

![This is a graph of fread() buffered block read call throughput](dirWorking/fread/fread.svg)
