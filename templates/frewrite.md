## Frewrite

This test measures the performance of writing a file using the library function
fwrite(). This is a library routine that performs buffered & blocked write 
operations. The buffer is within the user’s address space. If an application 
were to write in very small size transfers then the buffered & blocked I/O 
functionality of fwrite() can enhance the performance of the application by 
reducing the number of actual operating system calls and increasing the size of
the transfers when operating system calls are made. This test is writing to an
existing file so the performance should be higher as there are no metadata
operations required.

![graph of write performance](dirWorking/frewrite/frewrite.svg)
