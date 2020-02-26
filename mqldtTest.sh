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

if [[ $qm -eq 1 ]]; then
	./mqldt --dir=$dir --bsize=16K,32K,64K,128K,256K,512K,1024K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration
else
	# Create new directories for multi qm
        for index in 1 .. $qm
	do
		mkdir -p $dir/mqldt$index
	done
	if [[ $qm -gt 1 ]]; then
		./mqldt --dir=$dir/mqldt --bsize=128K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=1
	fi
        if [[ $qm -gt 2 ]]; then
                ./mqldt --dir=$dir/mqldt --bsize=128K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=2
        fi
        if [[ $qm -gt 4 ]]; then
                ./mqldt --dir=$dir/mqldt --bsize=128K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=4
        fi
        if [[ $qm -gt 8 ]]; then
                ./mqldt --dir=$dir/mqldt --bsize=128K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=8
        fi
        if [[ $qm -le 10 ]]; then
                ./mqldt --dir=$dir/mqldt --bsize=128K --fileSize=$fileSize --numFiles=$numFiles --csvFile=$csvFile --duration=$duration --qm=$qm
        fi
fi

echo "----------------------------"
echo "CSV Results ----------------"
echo "----------------------------"

cat $csvFile
