# Fwrite

This test measures the performance of writing a file using the library function
fwrite(). This is a library routine that performs buffered write operations. The
buffer is within the user’s address space. If an application were to write in
very small size transfers then the buffered & blocked I/O functionality of 
fwrite() can enhance the performance of the application by reducing the number 
of actual operating system calls and increasing the size of the transfers when
operating system calls are made. This test is writing a new file so again the 
overhead of the metadata is included in the measurement. 


![Graph of fwrite() function performance](dirWorking/fwrite/fwrite.svg)

