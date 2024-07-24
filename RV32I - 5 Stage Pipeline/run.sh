#!/bin/bash
# test=""
# compile_flag=0
# compile_full_flag=0;

# while getopts 'ta:' flag; do
# 	case $flag in 
# 		t) test=$OPTARG;;\
# 		a) compile_full_flag=1;;\
# 	esac
# done

clear

echo ""
echo "Updating Repo..."
echo ""
git pull


echo ""
echo "Compiling..."
echo "RV32I - 5 Stage Pipeline Model..."
echo ""
vlog -f ins.list

echo ""
echo "Simulating..."
echo ""
vsim tb -c -do "run -all" 


echo ""
echo "Script End..."
echo ""