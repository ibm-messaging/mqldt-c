#!/bin/bash

echo "----------------------------"
echo "Running MQLDT Tests --------"
echo "----------------------------"
echo $(date)
echo ""

dir=${MQLDT_DIRECTORY:-"/tmp"}
csvFile=${MQLDT_CSVFILE:-"mqldt.csv"}
fileSize=${MQLDT_FILESIZE:-67108864}
numFiles=${MQLDT_NUMFILES:-16}
duration=${MQLDT_DURATION:-60}

./mqldt --dir=$dir --bsize=16K,32K,64K,128K,256K,512K,1M --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration

echo "----------------------------"
echo "CSV Results ----------------"
echo "----------------------------"

cat $csvFile
