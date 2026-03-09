## Freread

This test is the same as fread above except that in this test the file that is
being read was read in the recent past so the buffer and cache hit rage should
be high; this should result in significantly higher performance as the operating
system is likely to have the file data in cache. This test may be helpful in 
tuning buffer and cache settings.

![This is a repeat of the fread() call; this time the call should be hitting buffers and cache first.](dirWorking/freread/freread.svg)
