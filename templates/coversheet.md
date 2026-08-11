<!--
Command to render PDF: 
pandoc -f markdown_phpextra+raw_html templates/coversheet.md -t html --pdf-engine=wkhtmltopdf --pdf-engine-opt=--enable-local-file-access --pdf-engine-opt=--margin-top --pdf-engine-opt=0 --pdf-engine-opt=--margin-bottom --pdf-engine-opt=0 --pdf-engine-opt=--margin-left --pdf-engine-opt=0 --pdf-engine-opt=--margin-right --pdf-engine-opt=0 --pdf-engine-opt=--page-size --pdf-engine-opt=Letter -o coversheet.pdf
-->
<style>
@page {
    margin: 0;
}

html, body {
    margin: 0;
    padding: 0;
    background-color: #ffffff;
}

/* Forces the page to retain exact layout proportions regardless of unpatched engine scaling */
.letter-page {
    position: relative;
    width: 612pt;
    height: 792pt;
    box-sizing: border-box;
    overflow: hidden;
}

/* Placed directly at the back of the element stack */
.watermark-layer {
    position: absolute;
    top: 0;
    left: 0;
    width: 612pt;
    height: 792pt;
    z-index: 1;
}

.watermark-img {
    width: 100%;
    height: 100%;
    display: block;
}

/* Content block safely floats on top of the graphics layer */
.content-layer {
    position: absolute;
    top: 0;
    left: 0;
    width: 612pt;
    height: 792pt;
    z-index: 10;
    box-sizing: border-box;
    padding-top: 180pt;
    padding-bottom: 72pt;
    padding-left: 45pt;
    padding-right: 45pt;
    
    font-family: "RedHatText-Regular", sans-serif;
    font-size: 11pt;
    line-height: 1.5;
    color: #000000;
}

.header-wrapper {
    width: 522pt;
    margin-bottom: 35pt;
}

.logo-alignment {
    text-align: left;
    margin-bottom: -45pt;
}

.title-alignment {
    text-align: right;
}

h1 {                                                                            
   font-size: 24pt;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 0;
   margin-bottom: 4pt;
}

h2 {                                                                            
   font-size: 16pt;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 0;
   margin-bottom: 0;
}

.section-title {
   font-size: 18pt;
   font-family: "RedHatText-Bold", sans-serif;
   margin-top: 25pt;
   margin-bottom: 8pt;
}

.logo-graphic {
   width: 180pt;
   height: auto;
   display: block;
}

.paragraph-block {
    width: 522pt !important;
    text-align: left;
    margin-bottom: 15pt;
}

.utility-row {
    margin-top: 15pt;
    margin-bottom: 15pt;
    width: 522pt !important;
}

.utility-label {
    font-family: "RedHatText-Bold", sans-serif;
    font-size: 12pt;
    margin-bottom: 2pt;
    color: #cc0000;
}

.utility-desc {
    font-size: 11pt;
    line-height: 1.4;
}
</style>

<div class="letter-page">
    <!-- Embedded watermark layout bypassing all command-line flag errors -->
    <div class="watermark-layer">
        <img src="file:///opt/iozone/img/redhatConsulting.svg" class="watermark-img" />
    </div>

    <div class="content-layer">
        <div class="header-wrapper">
            <div class="logo-alignment">
                <img src="file:///opt/iozone/img/RedHat-Speedo.svg" class="logo-graphic" />
            </div>
            <div class="title-alignment">
                <h1>Storage Benchmark Testing</h1>
                <h2>Red Hat Consulting</h2>
            </div>
        </div>

        <h2 class="section-title">Overview</h2>
        <div class="paragraph-block">
            In today’s data-driven landscape, storage performance testing is a critical strategic investment that ensures your infrastructure can reliably support business growth and digital transformation. By proactively identifying bottlenecks before they impact operations, enterprise leaders can optimize capital expenditures, reduce the risk of costly system downtime, and ensure that mission-critical applications deliver the seamless experience customers expect. Ultimately, rigorous performance validation transforms storage from a potential liability into a high-performing asset that drives operational efficiency and provides a measurable competitive advantage.
        </div>

        <h2 class="section-title">How we benchmark storage</h2>
        <div class="paragraph-block">
            When Red Hat implements storage infrastructures (including Gluster, Ceph, etc.) our consultants and engineers use a mix of tools and methodologies to benchmark the delivered solution before it is handed off to the customer. The tools Red Hat consultants employ may include:
        </div>

        <div class="utility-row">
            <div class="utility-label">scp</div>
            <div class="utility-desc">scp, or "secure copy" (which is often used synonymously with sftp) is another invaluable tool for testing a combination of filesystem and filesystem throughput. As a normal part of its usage it will report the average file transfer speed, which makes it useful for testing network speed. However, as scp and sftp are both very "chatty" protocols, there is more overhead than actual storage protocols such as NFS and iscsi.</div>
        </div>

        <div class="utility-row">
            <div class="utility-label">dd</div>
            <div class="utility-desc">dd is a userland tool that is bundled with the coreutils package which is installed by default with Red Hat distributions, including Red Hat Enterprise Linux, Fedora, and CentOS. It is invaluable for creating test files, both structured and ad-hoc structured testing of storage throughput, and for duplicating block and file storage. dd is also often used as a utility for wiping previous filesystems before reclaiming block storage, and to create test files of specific sizes.</div>
        </div>

        <div class="utility-row">
            <div class="utility-label">iozone</div>
            <div class="utility-desc">iozone is an open source utility that Red Hat consultants and engineers often employ for testing filesystem throughput, as it is capable of performing a wide variety of standardized filesystem performance tests.</div>
        </div>

        <div class="utility-row" style="margin-top: 25pt;">
            <h2 class="section-title" style="margin-top: 0;">Specific Benefits</h2>
            <div class="paragraph-block">
                In addition to simply providing end users with faster file access, tuning storage for optimal performance can help resolve application and cloud computing bottlenecks by reducing await and svctime. Whenever an application pauses while waiting for storage requests to be fulfilled, it enters a "diskwait" state which causes the application to halt until the storage request is fulfilled. Normally, this is not noticed by the end users, but when load on a server is high, slow concurrent storage requests tend to cause processing and storage requests to back up, resulting in slower performance which <em>is</em> felt by end users.
            </div>
        </div>
    </div>
</div>
