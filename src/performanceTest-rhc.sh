#!/bin/bash
#
# Development started by Kimberly Lazarski in March, 2026
# Contact info: klazarsk@redhat.com
#
# Bugs fixed: Made compatible with modern builds of gnuplot
#             Added a shebang (interpreted scripts called from
#             a shell should always include a shebang so it runs
#             even for users who use tcsh or other oddball shells!)
#
# Features added:
#  - Flexible command line options
#    - Made pathing arbitrary
#    - enabled ability to adapt to alternate install locations
#    - Added help screen
#  - Integrated performance testing
#  - Integrated graph generation 
#  - Integrated template-driven report generation
#  - Making reports fully customizable to allow for performance 
#    and systems analysis
#
# ToDo: Add GPLv2 or GPLv3 license header
#
# This script will create the Iozone graphs using
# gnuplot.
#
###############################
#
# Set some sane default values for stuff 

dirWorking="${PWD}";
# get the command line with arguments
cmdLine="${0} ${@}";
unset arrBenchmarks;
declare -a arrBenchmarks;
for itemBenchmark in write rewrite read reread randread randwrite bkwdread recrewrite strideread fwrite frewrite fread freread;
do
  arrBenchmarks+=("${itemBenchmark}");
done;
unset itemBenchmark;
intColumns=4;

echo "arrBenchmarks: [${arrBenchmarks[@]}]"
#echo "Pausing for 5 seconds..."
#sleep 5;

if [ -e /etc/iozone.conf ];
then
  source /etc/iozone.conf;
else
  #dirIozone="/opt/iozone"
  dirIozone="/opt/iozone";
fi;
dirIozoneBin="${dirIozone}/bin"
#dirIozoneBin="${dirIozone}";performanceTest-rhc.sh
unset intThreads;
unset optSetupTemplates;
optUnmount=0;
fileInput="iozone.out"
echo "id: $(id)"
touch foo; ls -lh foo; rm foo;

###############################
#
# Setting ANSI formatting tags

otagBold="\e[1m";
ctag="\e[0m";
otagRed='\e[0;31m';
otagRevRed='\e[0;101m';
otagUline="\e[4m";
otagItal="\e[3m";

#
###############################
#
# Command alias defaults

cmdAnyKey='read -n 1 -s -r -p "Press any key to continue..."';
cmdDate='date +%Y-%m-%d_%H:%M:%S';
cmdDbgEcho="true";
cmdDbgRead="true";
cmdDbgSleep="true";
cmdDbgAnyKey="true";
cmdExec="exec"; 

#
###############################${LINENO}:
#
# Function Definitions

fnHelp() {
  # This is the help screen
  echo "This will be a help screen. Honest!";
}

fnCheckMount() {

  if awk -v mountpoint="${dirMountPoint}" '$2 == mountpoint {found=1} END {if (!found) exit 1}' /etc/fstab;
  then
    echo "${dirMountPoint} is defined as a mount point in /etc/fstab. Checking its status..."; 
    if ! awk -v mountpoint="${dirMountPoint}" '$2 == mountpoint {found=1} END {if (!found) exit 1}' /proc/mount;
    then
      echo "${dirMountPoint%/} is already mounted. Remounting.";
      mount -v -o remount "${dirMountPoint}";
    else 
      echo "Attempting to mount ${dirMountPoint}";
      if ! mount -v "${dirMountPoint}";
      then
        echo "I was unable to mount ${dirMountPoint}; exiting.";
        exit 1;
      fi;
    fi;
  else
    echo "${otagRed}${otagBold}ERROR: ${dirMountPoint} is not defined as a mount point in /etc/fstab.${ctag}";
    echo "Please check your command and try again.";
    echo -e "\t${otagRed}$0${ctag}";
    exit 1;
  fi;

}


#
###############################
# Since user gave us stuff to do, let's process arguments. Party on!
while [ "${1}" != "" ] ;
do
  case ${1} in
    -h | "--help" ) fnHelp;
                    exit 0;
                    ;;
    -c | "--columns"* ) if [[ "${1}" != *'='* ]]; then shift; fi;
                    if [[ "$1" =~ ^[0-9]+$ ]]; then intColumns=$1; fi;
                    ;;
    -D | "--debug" )  optDebug=1;
                      cmdDbgRead="read";
                      cmdDbgSleep="sleep";
                      cmdDbgEcho="echo";
                      cmdDbgAnyKey='eval echo  "Debug mode: Press any key to continue..."; read -n 1 -s -r ';
                      cmdExec="true";
                    ;;
    -i | "--input"* ) if [[ "${1}" != *'='* ]]; then shift; fi;
                      fileInput="${1##*=}";
                      fileInput="${fileInput%/}";
                    ;;
    -m | "--mountpoint"* ) if [[ "${1}" != *'='* ]]; then shift; fi; 
                      dirMountPoint="${1##*=}";
                      dirMountPoint="${dirMountPoint%/}";
                    ;;
    -p | "--test-path"* ) if [[ "${1}" != *'='* ]]; then shift; fi;
                      dirTestPath="${1##*=}";
                      dirTestPath="${dirTestPath%/}";
                    ;;
    -s | "--skip-benchmark" ) optSkipBenchmark=1;
                    ;;
    -S | "--setup-templates" ) optSetupTemplates=1;
                    ;;
    -t | "--threads"* ) if [[ "${1}" != *'='* ]]; then shift; fi;
                      intThreads="${1##*=}";
                      if [[ "${intThreads}" =~ [^0-9] ]]; 
                      then
                        echo -e "${otagBold}${otagRed}--threads=${intThreads} does not specify an integer; please check your command and try again.${ctag}";
                        echo "Command: ${cmdLine}";
                        exit 1;  
                      fi;
                    ;;
    -u | "--unmount" ) optUnmount=1;
                    ;;
    -w | "--working-dir"* ) if [[ "${1}" != *'='* ]]; then shift; fi; 
                      dirWorking="${1##*=}";
                      dirWorking="${dirWorking%/}";
                      ${cmdDbgEcho} "${LINENO}: Setting dirWorking=${dirWorking}";
                    ;;
    * ) if [[ "${1}" != *'='* ]]; then shift; fi;
                      fnHelp;
                      exit 1;
                    ;;
  esac ;
  shift ;
done;

###################################
# Sanity checks
#

echo "checking arguments for sanity's sake";
${cmdDbgEcho} "strIozone=${dirIozone}";

echo "Command: ${cmdLine}";
                        
${cmdDbgEcho} "strIozoneBin=${dirIozoneBin}";
${cmdDbgEcho} "fileInput=${fileInput}";
${cmdDbgEcho} "dirWorking=${dirWorking}";
${cmdDbgAnyKey};


# Check and set $dirWorking sanely
echo "dirWorking=${dirWorking} and PWD=${PWD}";
if [[ "${dirWorking}" != "${PWD}" ]];
then
  if [ -d "${dirWorking}" ];
  then
    pushd "${dirWorking}";
    ${cmdDebugEcho} "${LINENO}: Switched to ${PWD} which should be --working-dir=${dirWorking}";
  else
    echo "${otagBold}${otagRed}ERROR: the specified --working-dir [${dirWorking} ] does not exist.${ctag}";
    echo "Command: ${cmdLine}";
    exit 1;
  fi;
fi;

# Verify the test path exists
if [ -n "${dirTestPath}" ];
then
  if [ ! -d "${dirTestPath}" ];
  then
    echo "${otagBold}${otagRed}ERROR: the specified --test-path ${dirTestPath} does not exist. Check your command and try again.${ctag}";
    echo "Command line: ${cmdLine}";
    exit 1;
  fi;
else
  dirTestPath="{PWD}";
fi;

# Advise user when # threads > # vCPUs
if [[ "${intThreads}" -gt "$(nproc)" ]];
then
  echo "--threads=${intThreads} is greater than the number of threads $(nproc) that the number of CPUs this this system has.";
  ${cmdDbgAnyKey};
  for intCount in {05..01} ; 
  do 
    echo -n "${intCount}..."; 
    sleep 12; 
    echo -en "\b\b\b\b\b" ; 
  done;
  echo "...Continuing";
fi;
${cmdDbgAnyKey};

if [[ -d "${dirWorking/templates}" ]];
then
  dirTemplates="${dirWorking}/templates";
else
  dirTemplates="${dirIozone}/templates";
fi;

if [[ -d "${dirWorking}/styles" ]]
then
  dirTemplates="${dirWorking}/styles";
else
  dirTemplates="${dirIozone}/styles";
fi;

#
###################################
#
## Set up the report directory  
##  - ensure the call is exclusive
##  - copy original templates over 
#


  if [[ "${optSetupTemplates}" -eq 1 ]];
  then
    if [[ -n "${fileInput}" || -n "${dirTestPath}" || -n "${dirMountPoint}" ]];
    then
      echo "${otagBold}${otagRed}ERROR: --setup-templates is to be run exclusively.${ctag}";
      fnHelp;
      exit 1;
    else
      mkdir templates;
      cp -v "${dirIozone}/templates/*.md" "${dirWorking}/templates/";
      echo "The base templates have been copied to ${dirWorking/templates}. For customized 
      reports, edit the markdown files in ${dirWorking}/templates to add your analysis 
      and recommendations.";
      exit 0; 
    fi;
  fi;

#
###################################
# 
  # run iozone and generate the data

  if [[ "${optUnmount}" -eq 1 ]];
   then 
    fnCheckMount;￼
    argUmount="-U ${dirMountPoint}";
  fi;

  if [[ "${optSkipBenchmark}" -ne 1 ]];
  then
    if [[ -z "${intThreads}" ]];
    then
      echo "Running the plain Jane benchmark. dirTestPath=${dirTestPath}, argUmount=${argUmount}, PWD=${PWD}"
      iozone -Raz -n 4 -f "${dirTestPath}/testfile" "${argUmount}" | tee iozone.out;
    else
      # test with ${intThreads} threads.
      for item in $(seq 1 ${intThreads});
      do
        strTestFiles+=" ${dirTestPath}/testFile${item}";
      done;
      iozone -Rz -n 4 -F "${strTestFiles}" -t ${intThreads} "${argUmount}" | tee iozone.out;
    fi;
    echo "Results saved to ./iozone.out.";
  else
    echo "User opted out of generating new benchmark data.";
  fi;

#￼
###################################
#
# Generate the data directories and graphs
# Generate data base for all of the operation types.
# Do the stuff Generate_Graphs attempted to do, but do it smarter and better
#

  #################################
  #
  ## Generate the individual report databases
  #
  for itemBenchmark in "${arrBenchmarks[@]}";
  do

    ${cmdDbgEcho} "${LINENO}: dirIozoneBin=${dirIozoneBin}, Current benchmark=${itemBenchmark}"
    echo "Plotting graph for ${itemBenchmark}..."
    ${cmdDbgEcho} "fileInput=${fileInput}"
    ls -lh "${dirIozoneBin}/gengnuplot.sh"
    echo "${LINENO}Pausing for 5 seconds..."
    sleep 5
    "${dirIozoneBin}/gengnuplot.sh" "${fileInput}" ${itemBenchmark};
    #"${dirIozoneBin}/Generate_Graphs" --input="${fileInput}";

    # ${itemBenchmark};
  done;..
  #
  ## Isn't this a better way to do it?
  ## This concludes the stuff Generate_Graphs originally tried to do. That's
  ## only a small part of what is needed for a proper benchmark report and
  ## systems analysis.    if [[ -z "${intThreads}" ]];

  #
  # ###############################

echo "running gnuplot"
gnuplot "${dirIozoneBin}/gnu3d.dem"
unset itemBenchmark;

# percentage width for tables in grid
perWidth=$(( 100 / ${intColumns} ));
unset grdColumns;
for intCounter in $(seq 1 ${intColumns} );
do
  ${cmdDbgEcho} "reticulating splines" >&2;
  grdColumns+="1fr ";
done;

## create the html raw data report using RedHatText fonts
for itemBenchmark in "${arrBenchmarks[@]}";
do
  ######
  #############
  ####################
  ############################
  ###################################
  # 
  ## Make the performance reports
  ## This is where the real work begins
  ## 
  
  pushd "${itemBenchmark}";

  unset arrPerformance;
  declare -A arrPerformance;
  unset intCounter;
  
  
  #echo "${grdColumns} break"; sleep 9000;
  
  echo "Redirecting output to ${PWD}/${itemBenchmark}.html";
  ${cmdDbgEcho} "stdout redirected to file for prod, to console for debug mode."
  ${cmdExec} 3>&1;
  ${cmdExec} >"${itemBenchmark}.html";
  echo -n '<style>
  
  .grid-container {p
    display: grid;
    /* Creates 3 columns of equal width (1fr unit) */
    grid-template-columns: '; echo "${grdColumns}"';
    /* Creates rows with automatic height */
    grid-template-rows: auto auto;
    gap: 10px; /* Adds spacing between items */￼
  }
  
  .grid-container div {#



    border: 1px solid #ccc;
    padding: 8pt;
    text-align: center;
  }
  
  h1 {
     font-size: 36pt;
     font-family: "RedHatText-Bold", sans-serif;
     margin-top: 0;
  }
  .tdtitle {
    text-align: center;
    font: small-caps 12pt "RedHatText-Bold", sans-serif;
    margin-top: 0;
    font-weight: bold; 
  
  .tdheading {
    text-align: center;
    font: small-caps 10pt "RedHatText-Bold", sans-serif;
    margin-top: 0;
    font-weight: bold;
  }
  
  td.data {
    text-align: center;
    font-size: 10pt;
    font-family: "RedHatText-Light", sans-serif;
    margin-top: 0;
    border-width: 0px 0px 1px 0px;
    border-style: dashed;
  }
  </style>
  
  ';
  
  echo "<h1>Performance benchmark: ${itemBenchmark}, raw data.</h1>";
  for szFile in $(awk '$1 ~ /^[0-9]/ {print $1}' iozone_gen_out.gnuplot | uniq);
  do
    ((intCounter++));
    if [ $(( ${intCounter} % ${intColumns} )) = 1  ];
    then
      echo '<div class="grid-container">';
    fi;
      echo '  <div>';
      echo '    <table>
        <tr>
          <td class="tdtitle" colspan=2>File size: '; printf "%'d" ${szFile}; echo ' kB</td>
        </tr>
        <tr>
         <td class="tdheading">Record Size(kB)</td><td class="tdheading">Throughput(kB/s)</td>
        </tr>';
      for szRecord in $(awk -v szFile="${szFile}" '$1 == szFile {print $2}' iozone_gen_out.gnuplot);
      do
        for intThroughput in $(awk -v szFile="${szFile}" -v szRecord="${szRecord}" '$1 == szFile && $2 == szRecord {print $3}' iozone_gen_out.gnuplot);
        do
          echo -n '        <tr>
            <td class="data">'; printf "%'d" ${szRecord}; echo -n '</td><td class="data">'; printf "%'d" ${intThroughput}; echo '</td>
          </tr>';
        done;
      done;
      echo "    </table>
    </div>";
    if [ $(( ${intCounter} % ${intColumns} )) = 0  ];
    then
      echo "</div>";
    fi;
  done;
  echo "</div>"
  ${cmdExec} 1>&3;
  ${cmdExec} 3>&-
  popd;
  ${cmdDbgEcho} "exec redirect to file should be terminated."
  ${cmdDbgEcho} "stdout redirected back to screen!";
done;
  ###################################
  ############################
  ####################
  #############
  ######


#
###################################
#
# Now, generate the Completed graph and integrate the reports
#

pandoc -f markdown_phpextra+raw_html ReportPage.md -t html -c "${dirTemplates}/reportpage.css" --pdf-engine=wkhtmltopdf \
  --pdf-engine-opt=--enable-local-file-access --pdf-engine-opt=--margin-top --pdf-engine-opt=0 --pdf-engine-opt=--margin-bottom \
  --pdf-engine-opt=0 --pdf-engine-opt=--margin-left --pdf-engine-opt=0 --pdf-engine-opt=--margin-right --pdf-engine-opt=0 \
  --pdf-engine-opt=--page-size --pdf-engine-opt=Letter -o "${dirWorking}reportpage.pdf"



#
#
##########################



if [[ "$(dirs -0)" != "${PWD}" ]];
then
  popd;
fi;


