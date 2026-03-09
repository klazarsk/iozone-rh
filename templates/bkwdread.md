## Backwards Read

This test measures the performance of reading a file backwards. This may seem 
like a strange way to read a file but in fact there are applications that do 
this. MSC Nastran is an example of an application that reads its files 
backwards. With MSC Nastran, these files are very large (Gbytes to Tbytes in 
size). Other examples include log aggreggators and peformance metrics and 
analysis suites. Although many operating systems have special features that
enable them to read a file forward more rapidly, there are very few operating
systems that detect and enhance the performance of reading a file backwards.

![This is a graph of the performance of reading a file backwards, such as log aggregation](dirWorking/bkwdread/bkwdread.svg)
