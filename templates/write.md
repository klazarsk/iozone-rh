## Write

This test measures the performance of writing a new file. When a new file is 
written not only does the data need to be stored but also the overhead
information for keeping track of where the data is located on the storage media.
This overhead is called the “metadata” It consists of the directory information,
the space allocation and any other data associated with a file that is not part
of the data contained in the file. It is normal for the initial 
write performance to be lower than the performance of rewriting a file due to
this overhead information.

![graph of write performance](dirWorking/write/write.svg)

