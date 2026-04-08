<!--


Command to render PDF: pandoc -f markdown_phpextra+raw_html coversheet.md -t html --pdf-engine=wkhtmltopdf --pdf-engine-opt=--enable-local-file-access --pdf-engine-opt=--margin-top --pdf-engine-opt=0 --pdf-engine-opt=--margin-bottom --pdf-engine-opt=0 --pdf-engine-opt=--margin-left --pdf-engine-opt=0 --pdf-engine-opt=--margin-right --pdf-engine-opt=0 --pdf-engine-opt=--page-size --pdf-engine-opt=Letter -o coversheet.pdf

Command to check PDF rendering and verify via a virtual screenshot (coversheet.png): pdftoppm -png -f 1 -l 1 coversheet.pdf coversheet.png
-->
<style>
@page {
    margin: 0;
}

html {
    margin: 0;
    padding: 0;
    width: 100%;
    /* Forced scaling to ensure it hits all edges */
    background-image: url("file://dirIozone/img/RH_Consulting_header_2700x750_grey.png"); 
    background-position: center top;
    background-repeat: no-repeat;
    background-size: 100%;
}

body {
    margin: 0;
    /* 
       padding-top: 2.5in clears the top of the watermark.
       padding-bottom: 1.0in ensures a margin at the bottom of the first page.
    */
    padding: 3.25in 0.5in 1.0in 0.5in;
    box-sizing: border-box;
    /* Disable Pandoc's default max-width constraint */
    max-width: none !important; 
    width: 100% !important;
    font: 16px/1.5 "RedHatText-Regular", sans-serif; 
    background: transparent;
}

p {                                                                             
   font: "RedHatText-Regular" 12px/1.5, sans-serif;                   
}                                                                               
                                                                                
h1 {                                                                            
   font-size: 36px;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 0;
}

h2 {                                                                            
   font-size: 24px;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 0;
}
.logo {
   width: 300px;
   height: auto;
   display: block;
}

table {
   width: 100%;
   border-collapse: collapse;
   border: none !important;
   table-layout: fixed; /* Ensures column widths are respected */
}

td {
   vertical-align: top;
   border: none !important;
   padding: 0;
}

/* Colgroup ensures the first column is wide enough for the logo */
.col-logo { width: 300px; }
.col-text { width: auto; }

</style>


<!--
<table width="100%">
<colgroup>
    <col class="col-logo">
    <col class="col-text">
</colgroup>
<tr>
    <td><img src="file:///home/klazarsk/github/iozone/img/RedHat-Speedo.svg" class="logo" /></td>
    <td style="text-align: right; font-weight: bold;">
      <h1>Storage Benchmark Testing</h1>
      <h2>Red Hat Consulting</h2>
    </td>
</tr>
<tr>
<td colspan="2" style="padding: 0px;">
<h2>Overview</h2>
In today’s data-driven landscape, storage performance testing is a critical strategic investment that ensures your infrastructure can reliably
support business growth and digital transformation. By proactively identifying bottlenecks before they impact operations, enterprise leaders can
optimize capital expenditures, reduce the risk of costly system downtime, and ensure that mission-critical applications deliver the seamless
experience customers expect. Ultimately, rigorous performance validation transforms storage from a potential liability into a high-performing asset
that drives operational efficiency and provides a measurable competitive advantage.
</td>
</tr>
<tr>
<td colspan=2>
<h2>How we benchmark storage</h2>
When Red Hat implements storage infrastructures (including Gluster, Ceph, etc.) our consultants and engineers use a mix of tools and methologies to benchmark the the delivered solution before it is handed off to the customer. The tools Red Hat consultants employ may include: 
</td>
</tr>
<tr>
    <td style="padding: 10px; text-align: right;">
        scp
    </td>
    <td style="padding: 10px; text-align: left;">
        scp, or "secure copy" (which is often used synonymously with sftp) is another invaluable tool for testing a combination of filesystem and filesystem throughput. As a normal part of its usage it will report the average file transfer speed, which makes it useful for testing network speed. However, as scp and sftp are both very "chatty" protocols, there is more overhead than actual storage protocols such as NFS and iscsi.
    </td>
</tr>
</tr>
<tr>
    <td style="padding: 10px; text-align: right;">
        dd
    </td>
    <td style="padding: 10px; text-align: left;">
        dd is a userland tool that is bundled with the coreutils package which is installed by default with Red Hat distributions, including Red Hat Enterprise Linux, Fedora, and CentOS. It is invaluable for creating test files, both structured and ad-hoc structured testing of storage throughput, and for duplicating block and file storage. dd is also often used as a utility for wiping previous filesystems before reclaiming block storage, and to create test files of specific sizes.</p>
    </td>
</tr>
<tr>
    <td style="padding: 10px; text-align: right;">
        iozone
    </td>
    <td style="padding: 10px; text-align: left;">
        iozone is an open source utility that Red Hat consultants and engineers often employ for testing filesystem throughput, as it is capable of performing a wide variety of standardized filesystem performance tests.
    </td>
</tr>
<td colspan=2 style="padding: 0px;">
<h2>Specific Benefits</h2>
In addition to simply providing end users with faster file access, tuning storage for optimal performance can help resolve application and cloud computing bottlenecks by reducing await and svctime. Whenever an application pauses while waiting for storage requests to be fulfilled, it enters a "diskwait" state which causes the application to halt until the storage request is fulfilled. Normally, this is not noticed by the end users, but when load on a server is high, slow concurrent storage requests tend to cause processing and storage requests to back up, resulting in slower performance which <em>is</em> felt by end users.
</td>
</tr>
</table>
-->

# fread() Benchmark

## Overview

This test measures the performance of reading a file using the library function
fread(). This is a library routine that performs buffered & blocked read 
operations. The buffer is within the user’s address space. If an application 
were to read in very small size transfers then the buffered & blocked I/O 
functionality of fread() can enhance the performance of the application by 
reducing the number of actual operating system calls and increasing the size of
the transfers when operating system calls are made.

## Results Graph
<html>
<img src="file:///home/klazarsk/github/iozone/img/fread.svg" width=
 alt="forward sequential read results" > 

X-axis: This is the total file size, in kB<br />
Y-axis: This is the filesystem throughput in kB/s<br />
Z-axis: This is the "record size" of each indivual I/O request, in kB<br />
</html>

## Analysis

This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. 

(Raw data on next page)
<html>

<style>
@page {
    margin: 0;
}

html {
    margin: 0;
    padding: 0;
    width: 100%;
    /* Forced scaling to ensure it hits all edges */
    background-image: url("file:////home/klazarsk/github/iozone/img/RH_Consulting_header_2700x3494_grey.png"); 
    background-position: center center;
    background-repeat: repeat;
    background-size: 100% 100%;
}

body {
    margin: 0;
    /* 
       padding-top: 2.5in clears the top of the watermark.
       padding-bottom: 1.0in ensures a margin at the bottom of the first page.
    */
    padding: 3.25in 0.5in 1.0in 0.5in;
    box-sizing: border-box;
    /* Disable Pandoc's default max-width constraint */
    max-width: none !important; 
    width: 100% !important;
    font: 16px/1.5 "RedHatText-Regular", sans-serif; 
    background: transparent;
}

p {                                                                             
   font: "RedHatText-Regular" 12px/1.5, sans-serif;                   
}                                                                               
                                                                                
h1 {                                                                            
   font: small-caps 36px "RedHatText-Bold", sans-serif;
   margin-top: 0;
}

h2 {                                                                            
   font-size: 24px;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 0;
}
.logo {
   width: 300px;
   height: auto;
   display: block;
}

table {
   width: 100%;
   border-collapse: collapse;
   border: none !important;
   table-layout: fixed; /* Ensures column widths are respected */
}

td {
   vertical-align: top;
   border: none !important;
   padding: 0;
}

/* Colgroup ensures the first column is wide enough for the logo */
.col-logo { width: 300px; }
.col-text { width: auto; }

</style>
<div style="height: 750px;"> </div>
</html>

## fread() Benchmark Raw Data


# Second Page

This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. This second page content. 

## Overview

This test measures the performance of reading a file using the library function
fread(). This is a library routine that performs buffered & blocked read 
operations. The buffer is within the user’s address space. If an application 
were to read in very small size transfers then the buffered & blocked I/O 
functionality of fread() can enhance the performance of the application by 
reducing the number of actual operating system calls and increasing the size of
the transfers when operating system calls are made.

## Raw Results

        Time Resolution = 0.000001 seconds.
        Processor cache size set to 1024 kBytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                
              kB  reclen      fread  
              64       4    1452528  
              64       8    1933893  
              64      16    1690338  
              64      32    4018152  
              64      64    1722886  
             128       4    3380677  
             128       8    4407601  
             128      16    5122535  
             128      32    7582312  
             128      64    5545860  
             128     128    8036304  
             256       4    4264168  
             256       8    2613746  
             256      16    4197489  
             256      32    7314033  
             256      64    9518507  
             256     128    9868433  
             256     256    9868433  
             512       4    4610256  
             512       8    6632013  
             512      16    7410080  
             512      32   10044089  
             512      64   10856530  
             512     128    4871723  
             512     256    9304292  
             512     512    9859630  
            1024       4    3655895  
            1024       8    6479979  
            1024      16    7699755  
            1024      32   10329265  
            1024      64   11249091  
            1024     128    9142007  
            1024     256    7420395  
            1024     512    8457895  
            1024    1024    7054742  
            2048       4    5041616  
            2048       8    4621211  
            2048      16    8029434  
            2048      32    5626082  
            2048      64   10240672  
            2048     128    8423109  
            2048     256    9796850  
            2048     512   10192069  
            2048    1024   11564174  
            2048    2048    7036283  
            4096       4    4000150  
            4096       8    6358661  
            4096      16    7111444  
            4096      32    7983931  
            4096      64    9105266  
            4096     128    8770583  
            4096     256    8356757  
            4096     512   12597006  
            4096    1024   12560167  
            4096    2048   10239486  
            4096    4096    7392988  
            8192       4    3382261  
            8192       8    7379976  
            8192      16    6644948  
            8192      32   10100441  
            8192      64    9515809  
            8192     128   12010511  
            8192     256    9742452  
            8192     512    9276873  
            8192    1024    9042498  
            8192    2048    9579481  
            8192    4096   11116757  
            8192    8192    8208631  
           16384       4    3862422  
           16384       8    7434110  
           16384      16    8151964  
           16384      32    9351108  
           16384      64    8432038  
           16384     128   13662451  
           16384     256    9940895  
           16384     512    9706407  
           16384    1024   12623425  
           16384    2048   10323191  
           16384    4096    9845471  
           16384    8192   10343390  
           16384   16384   10564416  
           32768       4    4405404  
           32768       8    7250876  
           32768      16    7009400  
           32768      32    8447485  
           32768      64   12244216  
           32768     128   11085748  
           32768     256   10550472  
           32768     512   11260129  
           32768    1024   11715072  
           32768    2048   10472492  
           32768    4096    9760730  
           32768    8192    8402040  
           32768   16384    7630916  
           65536       4    4411400  
           65536       8    5123558  
           65536      16    6618491  
           65536      32   10215924  
           65536      64   10706550  
           65536     128   10529378  
           65536     256    9629025  
           65536     512    9874621  
           65536    1024   10485597  
           65536    2048   10435836  
           65536    4096   13031832  
           65536    8192    8760544  
           65536   16384    7956220  
          131072       4    4023806  
          131072       8    5646988  
          131072      16    7504399  
          131072      32    8872924  
          131072      64   10438175  
          131072     128   12986519  
          131072     256    8860340  
          131072     512   10131542  
          131072    1024    8735183  
          131072    2048   10568608  
          131072    4096    9811495  
          131072    8192    7361505  
          131072   16384    7744806  
          262144       4    3758168  
          262144       8    5573163  
          262144      16    6559361  
          262144      32   10794468  
          262144      64    8317295  
          262144     128    9765120  
          262144     256    9888512  
          262144     512    8824911  
          262144    1024    8894084  
          262144    2048    8847493  
          262144    4096    8621131  
          262144    8192    8910734  
          262144   16384    7165378  
          524288       4    4339088  
          524288       8    5683716  
          524288      16    7379772  
          524288      32    8464592  
          524288      64    8721997  
          524288     128   10322850  
          524288     256    9225723  
          524288     512    9419481  
          524288    1024   10020438  
          524288    2048    8278276  
          524288    4096    9023899  
          524288    8192    9002509  
          524288   16384    7544807  

iozone test complete.


## Analysis

This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. This is our analysis. 

