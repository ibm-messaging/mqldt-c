#!/bin/bash

echo "----------------------------"
echo "Running MQLDT Tests --------"
echo "----------------------------"
echo $(date)
echo ""

dir=${MQLDT_DIRECTORY:-"/var/mqldt"}
csvFile=${MQLDT_CSVFILE:-"mqldt.csv"}
fileSize=${MQLDT_FILESIZE:-67108864}
numFiles=${MQLDT_NUMFILES:-16}
duration=${MQLDT_DURATION:-60}
qm=${MQLDT_QM:-1}
blocksize=${MQLDT_BLOCKSIZE:-128K}

if [[ $qm -eq 1 ]]; then
    ./mqldt --dir=$dir --bsize=16K,32K,64K,128K,256K,512K,1024K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration
else
    # Create new directories for multi qm. 1st QM will use $dir/mqldt. Subsequent QM will use $dir/mqldtx etc.
    mkdir -p $dir/mqldt
    for index in $(seq 1 $qm)
    do
        mkdir -p $dir/mqldt$index
        ./mqldt --dir=$dir/mqldt --bsize=$blocksize --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=$index
    done
fi

echo "----------------------------"
echo "CSV Results ----------------"
echo "----------------------------"

cat $csvFile
