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
for itemCurrentBenchmark in write rewrite read reread randread randwrite bkwdread recrewrite strideread fwrite frewrite fread freread;
do
  arrBenchmarks+=("${itemCurrentBenchmark}");
done;
unset itemCurrentBenchmark;

## Default number of columns to render in raw data report pages:
intColumns="4";
## default number of rows of raw data tables in raw data report pages: 
intRowsPerPage=3;

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

intDebugDelay="0.0005"
devTTY=$(readlink -f /proc/$$/fd/1)

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

fnSetupTemplates() {
    if [[ -n "${fileInput}" || -n "${dirTestPath}" || -n "${dirMountPoint}" ]];
    then
      echo -e "${otagBold}${otagRed}ERROR: --setup-templates is to be run exclusively.${ctag}";
      fnHelp;
      exit 1;
    else
      mkdir {templates,styles};
      cp -v "${dirIozone}/templates/*.md" "${dirWorking}/templates/";
      cp -v "${dirIozone}/styles/*.css" "${dirWorking}/styles/";
      echo "The base templates have been copied to ${dirWorking/templates}. For customized 
      reports, edit the markdown files in ${dirWorking}/templates to add your analysis 
      and recommendations.";
      exit 0; 
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
                    intTemp="${1##*=}"
                    if [[ "${intTemp}" =~ ^[0-9]+$ ]]; then intColumns=${intTemp}; fi;
                    unset intTemp;
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
    -r | "--rows-per-page" ) if [[ "${1}" != *'='* ]]; then shift; fi;
                      intTemp="${1##*=}";
                      if [[ "${intTemp}" =~ ^[0-9]+$ ]]; then intRowsPerPage=${intTemp}; fi;
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
    -v | "--verbose" ) cmdDbgEcho="echo";
                      ## We only want verbosity, not pauses changing of redirects
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

#
###################################
#
## Set up the report directory  
##  - ensure the call is exclusive
##  - copy original templates over 
#

  if [[ "${optSetupTemplates}" -eq 1 && ( -n "${fileInput}" || -n "${dirTestPath}" || -n "${dirMountPoint}" ) ]];
  then
    fnSetupTemplates;
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
${cmdDbgEcho} "Line ${LINENO}: dirTemplates=${dirTemplates}";

if [[ -d "${dirWorking}/styles" ]]
then
    dirStyles="${dirWorking}/styles";
else
    dirStyles="${dirIozone}/styles";
fi;
${cmdDbgEcho} "Line ${LINENO}: dirTemplates=${dirStyles}";




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
          #_# iozone -Raz -n 4 -f "${dirTestPath}/testfile" "${argUmount}" | tee iozone.out;
      else
          # test with ${intThreads} threads.
          for item in $(seq 1 ${intThreads});
          do
              strTestFiles+=" ${dirTestPath}/testFile${item}";
          done;
          #_# iozone -Rz -n 4 -F "${strTestFiles}" -t ${intThreads} "${argUmount}" | tee iozone.out;
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
for itemCurrentBenchmark in "${arrBenchmarks[@]}";
do

  ${cmdDbgEcho} "Line ${LINENO}: dirIozoneBin=${dirIozoneBin}, Current benchmark=${itemCurrentBenchmark}"
  echo "Generating data for ${itemCurrentBenchmark}..."
  ${cmdDbgEcho} "fileInput=${fileInput}"
  ${cmdDbgEcho} $(ls -lh "${dirIozoneBin}/gengnuplot.sh");
  ${cmdDbgEcho} "Line ${LINENO}: Pausing for 1 seconds..."; sleep .1
  "${dirIozoneBin}/gengnuplot.sh" "${fileInput}" ${itemCurrentBenchmark};
  #"${dirIozoneBin}/Generate_Graphs" --input="${fileInput}";

  # ${itemCurrentBenchmark};
done;
  #
  ## Isn't this a better way to do it?
  ## This concludes the stuff Generate_Graphs originally tried to do. That's
  ## only a small part of what is needed for a proper benchmark report and
  ## systems analysis.    if [[ -z "${intThreads}" ]];

  #
  # ###############################

echo "Generating charts..."
gnuplot "${dirIozoneBin}/gnu3d.dem"
unset itemCurrentBenchmark;

# percentage width for tables in grid
perWidth=$(( 100 / ${intColumns} ));


# >>>---> Start new set of charts for ${itemBenchmark}
for itemCurrentBenchmark in "${arrBenchmarks[@]}"; # >>>---> Start new set of data dumps for each benchmark 
do
  pushd "${itemCurrentBenchmark}" >/dev/null 2>&1 ;
  ${cmdDbgEcho} "Beginning raw data report for benchmark ${itemCurrentBenchmark}";
  #sleep 10;
  intRowsTotal=$(( $(awk '$1 ~ /^[0-9]/ {print $1}' iozone_gen_out.gnuplot | uniq | wc -l) / ${intColumns} + ( $(awk '$1 ~ /^[0-9]/ {print $1}' iozone_gen_out.gnuplot | uniq | wc -l) % ${intColumns} > 0 ) ));
  intPagesTotal=$(( ${intRowsTotal} / 3 + ( $intRowsTotal / 3 > 0 ) ));
  intPageCurrent=1;
  intRowCurrent=1;
  intChartCounter=1;

    unset item szFile arrTestFiles;
    declare -a szFile arrTestFiles;
  
    # Load array szFile with file sizes for ${itemCurrentBenchmark}
    for item in $(awk '$1 ~ /^[0-9]/ {print $1}' iozone_gen_out.gnuplot | uniq);
    do
        arrTestFiles+=("${item}");
    done; unset item;

    ${cmdDbgEcho} "Line ${LINENO}, benchmark=${itemCurrentBenchmark} in ${PWD}, intChartCounter==${intChartCounter}, intRowCurrent=${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay} seconds..." >${devTTY}; sleep ${intDebugDelay};



    # >>---> Start new chart per file size in ${itemCurrentBenchmark) data file
    for szFile in "${arrTestFiles[@]}";
    do
        ${cmdDbgEcho} "Line ${LINENO}: <--> back to for szFile in arrTestFiles...  |---| Checking if row 1, column 1: ---Row ${intRowCurrent}---, ||| Column $(( ${intChartCounter} % ${intColumns} )) ||| " >${devTTY}; sleep ${intDebugDelay}
        ${cmdDbgEcho} "Line ${LINENO}: Current page ##### [[[[ ${intPageCurrent} ]]]]  ##### ---Row ${intRowCurrent}---, ||| Column $(( ${intChartCounter} % ${intColumns} +1  )) ||| Chart Number ${intChartCounter}" >${devTTY};
        if [[ ${intChartCounter} -eq 1 || ( ${intRowCurrent} -eq 1 && $(( ${intChartCounter} % ${intColumns} )) -eq 1 ) ]];
        then
            ${cmdDbgEcho} "Line ${LINENO}, checking directory, currently ${PWD} and should be ${dirWorking}/${itemBenchmark} pausing for ${intDebugDelay} seconds..." >${devTTY}; sleep ${intDebugDelay};
            if [[ ! "${dirWorking}/${itemCurrentBenchmark}" == "${PWD}" ]];
            then
              pushd "${itemCurrentBenchmark}" >/dev/null 2>&1;
              ${cmdDbgEcho} "Line ${LINENO}: ^^^^^^^^^checking directory after pushd'ing, currently ${PWD} and should be ${dirWorking}/${itemBenchmark} pausing for ${intDebugDelay} seconds..." ; sleep ${intDebugDelay};
            fi;
            echo "Generating ${PWD}/${itemCurrentBenchmark}_page${intPageCurrent}.html";
            exec 3>&1 ;
            exec > "${itemCurrentBenchmark}_page${intPageCurrent}.html";
            ${cmdDbgEcho} "Line ${LINENO}: stdout redirected to file for prod, to console for debug mode." >${devTTY}
            ${cmdDbgEcho} "Line ${LINENO}, benchmark=${itemCurrentBenchmark} in ${PWD}, intChartCounter==${intChartCounter}, intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay} seconds..."  >${devTTY} ; sleep ${intDebugDelay};
            echo -n '<style>
            .grid-container {
            display: grid;  /* Creates 3 columns of equal width (1fr unit) */
            grid-template-columns: repeat('${intColumns}', 1fr); /* Creates rows with automatic height */
            grid-template-rows: auto auto;
            gap: 10px; /* Adds spacing between items */￼
            }
            .grid-container div {
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
            }
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
            echo "<h1>Performance benchmark: ${itemCurrentBenchmark}, raw data page ${intPageCurrent}.</h1>";
        fi;
        if [[ $(( ${intChartCounter} % ${intColumns} )) -eq 1  ]];
        then
            echo '<div class="grid-container">';
        fi;
        # <---<< If we're not starting a new page, this stanza was skipped
        ${cmdDbgEcho} "Line ${LINENO}: itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, szFile=${szFile} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay}..." >${devTTY} ; sleep ${intDebugDelay};
        ${cmdDbgEcho} "Line ${LINENO}: [ page ${intPageCurrent} ] ---Row ${intRowCurrent}--- ||| Column $(( ${intChartCounter} % ${intColumns} )) ||| {{ chart number ${intChartCounter} }}" >${devTTY}; sleep ${intDebugDelay}
        echo '<div><table>
        <tr>
            <td class="tdtitle" colspan=2>File size: '; printf "%'d" ${szFile}; echo ' kB Table Number: '${intChartCounter}'</td>
        </tr>
        <tr>
        <td class="tdheading">Record Size(kB)</td><td class="tdheading">Throughput(kB/s)</td>
        </tr>';
        # >>>---> New row per request size (szFile) per file size (szRequest)
        for szRequest in $(awk -v szFile="${szFile}" '$1 == szFile {print $2}' iozone_gen_out.gnuplot); 
        do
            for intThroughput in $(awk -v szFile="${szFile}" -v szRequest="${szRequest}" '$1 == szFile && $2 == szRequest {print $3}' iozone_gen_out.gnuplot);
            do
            echo -n '        <tr>
                <td class="data">'; printf "%'d" ${szRequest}; echo -n '</td><td class="data">'; printf "%'d" ${intThroughput}; echo '</td>
                </tr>';
            done;
        done;
        ${cmdDbgEcho} "Line ${LINENO}, ending table, itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, intChartCounter==${intChartCounter} szFile=${szFile} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}..." >${devTTY} ;
        # <---<< End table
        echo "    </table>
        </div>";
        ${cmdDbgEcho} "intChartCounter == 18, ${intChartCounter} % ${intColumns} == $(( ${intChartCounter} % ${intColumns} )), #arrTestFiles == ${#arrTestFiles[@]}" >${devTTY};
        #>>>----> Close row grid if this is the ${intColumns} column or if we are at the last chart for this benchmark.
        if [[ $(( ${intChartCounter} % ${intColumns} )) -eq 0 || "${intChartCounter}" -eq "${#arrTestFiles[@]}" ]];
        then
            echo "</div>";
            ${cmdDbgEcho} "Line ${LINENO}, ended row grid, benchmark=${itemCurrentBenchmark} intChartCounter==${intChartCounter} PWD=${PWD}, intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing..." >${devTTY} ; sleep ${intDebugDelay};
        fi;
        # <---<< End set of charts for ${itemBenchmark}
        ${cmdDbgEcho} "Line ${LINENO}: About to test if intRowCurrent (${intRowCurrent}) == 3" >&3; sleep ${intDebugDelay};
        if [[ ( ${intRowCurrent} -eq 3 && $(( ${intChartCounter} % ${intColumns} )) -eq 0 ) || ${intChartCounter} -eq ${#arrTestFiles[@]} ]];
        then
            #<----<< End of page
            echo "</div>"  ;
            ${cmdDbgEcho} "Line ${LINENO}: ended page, benchmark=${itemCurrentBenchmark} PWD=${PWD}, intChartCounter==${intChartCounter} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing..." >${devTTY} ; sleep ${intDebugDelay};
            exec 1>&3;
            exec 3>&-;
            ${cmdDbgEcho} "Line ${LINENO}: -->| exec redirect to file should be terminated." >${devTTY} ;
            ${cmdDbgEcho} "Line ${LINENO}: >>>[ ] stdout redirected back to screen!" >${devTTY} ;
            ${cmdDbgEcho} "Line ${LINENO}: about to popd; PWD=${PWD}"
            popd >/dev/null 2>&1;
            ${cmdDbgEcho} "Line ${LINENO}: just popd'd: PWD=${PWD}"
            ((intPageCurrent++));
            ${cmdDbgEcho} "Line ${LINENO}: Incremented page: intPageCurrent==${intPageCurrent}" >${devTTY} ;
            intRowCurrent=1;
            ${cmdDbgEcho} "Line ${LINENO}: Reset row: intRowCurrent===${intRowCurrent}" >${devTTY} ;
        elif [[ ( ${intRowCurrent} -lt 3 && $(( ${intChartCounter} % ${intColumns} )) -eq 0 ) ]];
        then
            ((++intRowCurrent));
            ${cmdDbgEcho} "Line ${LINENO}, ++++++Incrementing row++++++ itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, szFile=${szFile} intChartCounter==${intChartCounter} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay}..." >${devTTY} ; sleep ${intDebugDelay};
        fi;
        ((++intChartCounter));
        ${cmdDbgEcho} "Line ${LINENO}, --<**((boing))**>-- itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, szFile=${szFile} intChartCounter=${intChartCounter} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay}..." >${devTTY} ; sleep ${intDebugDelay};
    done;
    ${cmdDbgEcho} "Line ${LINENO},  --<**((boing))**>-- itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, szFile=${szFile} intChartCounter=${intChartCounter} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay}..." >${devTTY} ; sleep ${intDebugDelay};
done;
${cmdDbgEcho} "Line ${LINENO}, itemCurrentBenchmark=${itemCurrentBenchmark}, PWD=${PWD}, szFile=${szFile} intChartCounter==${intChartCounter} intRowCurrent==${intRowCurrent}, intPageCurrent=${intPageCurrent}, pausing for ${intDebugDelay}..." >${devTTY} ; sleep ${intDebugDelay};



if [[ "$(dirs -0)" != "${PWD}" ]];
then
  popd;
fi;

