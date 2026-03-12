<!--


Command to render PDF: pandoc -f markdown_phpextra+raw_html performance-testing-2.md -t html --pdf-engine=wkhtmltopdf --pdf-engine-opt=--enable-local-file-access --pdf-engine-opt=--margin-top --pdf-engine-opt=0 --pdf-engine-opt=--margin-bottom --pdf-engine-opt=0 --pdf-engine-opt=--margin-left --pdf-engine-opt=0 --pdf-engine-opt=--margin-right --pdf-engine-opt=0 --pdf-engine-opt=--page-size --pdf-engine-opt=Letter -o performance-testing-2.pdf

Command to check PDF rendering and verify via a virtual screenshot (performance-testing-2.png): pdftoppm -png -f 1 -l 1 performance-testing-2.pdf performance-testing-2.png
-->
<style>
@page {
    margin: 0;
}

html {
    margin: 0;
    padding: 0;
    height: 100%;
    /* Forced scaling to ensure it hits all edges */
    background-image: url("file:///home/klazarsk/github/iozone/img/redhatConsulting.svg"); 
    background-position: center center;
    background-repeat: no-repeat;
    background-size: 100% 100%;
}

body {
    margin: 0;
    /* 
       padding-top: 2.5in clears the top of the watermark.
       padding-bottom: 1.0in ensures a margin at the bottom of the first page.
    */
    padding: 2.5in 0.5in 1.0in 0.5in;
    box-sizing: border-box;
    /* Disable Pandoc's default max-width constraint */
    max-width: none !important; 
    width: 100% !important;
    font: 16px/1.5 "RedHatText-Regular", sans-serif; 
    background: transparent;
}

p {                                                                             
   font: small-caps 12px/1.5 "RedHatText-Regular", sans-serif;                   
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


<table width="100%">
<colgroup>
    <col class="col-logo">
    <col class="col-text">
</colgroup>
<!-- This table should be below/after the graphics at the top of the background/watermark. -->
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