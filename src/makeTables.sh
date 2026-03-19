#!/bin/bash


unset arrPerformance
declare -A arrPerformance
unset intCounter
# number of columns for table grid
intColumns="4";
# percentage width for tables in grid 
perWidth=$(( 100 / ${intColumns} ))
unset grdColumns
for intCounter in $(seq 1 ${intColumns} ); 
do
  echo "reticulating splines" >2
  grdColumns+="1fr "
done
#echo "${grdColumns} break"; sleep 9000;

echo -n '
<style>

.grid-container {
  display: grid;
  /* Creates 3 columns of equal width (1fr unit) */
  grid-template-columns: '; echo "${grdColumns}"';
  /* Creates rows with automatic height */
  grid-template-rows: auto auto;
  gap: 10px; /* Adds spacing between items */
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

'




echo "<h1>Performance benchmark: fread(), raw data.</h1>"
for szFile in $(awk '$1 ~ /^[0-9]/ {print $1}' iozone_gen_out.gnuplot | uniq);
do
  ((intCounter++))
  if [ $(( ${intCounter} % ${intColumns} )) = 1  ];
  then
    echo '<div class="grid-container">'
  fi
    echo '  <div>'
    echo '    <table>
      <tr>
        <td class="tdtitle" colspan=2>File size: '; printf "%'d" ${szFile}; echo ' kB</td>
      </tr>
      <tr>
       <td class="tdheading">Record Size(kB)</td><td class="tdheading">Throughput(kB/s)</td>
      </tr>'
    for szRecord in $(awk -v szFile="${szFile}" '$1 == szFile {print $2}' iozone_gen_out.gnuplot);
    do
      for intThroughput in $(awk -v szFile="${szFile}" -v szRecord="${szRecord}" '$1 == szFile && $2 == szRecord {print $3}' iozone_gen_out.gnuplot)
      do
        echo -n '        <tr>
          <td class="data">'; printf "%'d" ${szRecord}; echo -n '</td><td class="data">'; printf "%'d" ${intThroughput}; echo '</td>
        </tr>'
      done
    done
    echo "    </table>
  </div>"
  if [ $(( ${intCounter} % ${intColumns} )) = 0  ];
  then
    echo "</div>"
  fi
  
done

#echo "All keys:"

#echo ${!arrPerformance[@]}

#echo "Checking array keys:"

#echo "Now try to iterate through them:"

#for szFile in $(echo ${!arrPerformance[@]} | tr " " "\n" | sed 's/,.*//g' | sort -nu)
#do
#  echo "Size: ${szFile}"
#done




# echo "Checking array:"
# for index in "${!arrPerformance[@]}";
# do
#   echo "Index: ${index}, Value: ${arrPerformance[$index]}"
# done
