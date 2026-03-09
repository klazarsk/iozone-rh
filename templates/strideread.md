## Strided Read

This test measures the performance of reading a file with a strided access 
behavior. An example would be: Read at offset zero for a length of 4 Kbytes, 
then seek 200 Kbytes, and then read for a length of 4 Kbytes, then seek 200 
Kbytes and so on. Here the pattern is to read 4 Kbytes and then  Seek 200 Kbytes
and repeat the pattern. This again is a typical application behavior for
applications that have data structures contained within a file and is accessing
a particular region of the data structure. Most operating systems do not detect
this behavior or implement any techniques to enhance the performance under this
type of access behavior.

This access behavior can also sometimes produce interesting performance 
anomalies. An example would be if the application’s stride causes a particular 
disk, in a striped file system, to become the bottleneck.

![graph of strided read (varying record sizes)](dirWorking/strideread/strideread.svg)

