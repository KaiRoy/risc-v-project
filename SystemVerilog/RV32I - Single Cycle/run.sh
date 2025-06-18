#!/bin/bash
test=""
compile_flag=0
compile_full_flag=0;

while getopts 'ta:' flag; do
	case $flag in 
		t) test=$OPTARG;;\
		a) compile_full_flag=1;;\
	esac
done

clear

echo ""
echo "Updating Repo..."
echo ""
git pull


echo ""
echo "Compiling..."
if [[ ! $compile_full_flag ]] ; then
	if [[ $test == "I" ]] ; then
		echo "I_Type Modules Only..."
		echo ""
		vlog ./rtl/RISC-V_package.sv ./rtl/CPU_interface.sv ./tb/RISC-V_I_instr_tb.sv ./rtl/RISC-V_I_instr.sv
		compile_flag=1
	fi

	if [[ $test == "R" ]] ; then
		echo "R_Type Modules Only..."
		echo ""
		vlog ./rtl/RISC-V_package.sv ./rtl/CPU_interface.sv ./tb/RISC-V_R_instr_tb.sv ./rtl/RISC-V_R_instr.sv
		compile_flag=1
	fi

	if [[ $test == "B" ]] ; then
		echo "B_Type Modules Only..."
		echo ""
		vlog ./rtl/RISC-V_package.sv ./rtl/CPU_interface.sv ./tb/RISC-V_B_instr_tb.sv ./rtl/RISC-V_B_instr.sv
		compile_flag=1
	fi

	if [[ $test == "L" ]] ; then
		echo "L_Type Modules Only..."
		echo ""
		vlog ./rtl/RISC-V_package.sv ./rtl/CPU_interface.sv ./tb/RISC-V_L_instr_tb.sv ./rtl/RISC-V_L_instr.sv
		compile_flag=1
	fi

	if [[ $test == "S" ]] ; then
		echo "S_Type Modules Only..."
		echo ""
		vlog ./rtl/RISC-V_package.sv ./rtl/CPU_interface.sv ./tb/RISC-V_S_instr_tb.sv ./rtl/RISC-V_S_instr.sv
		compile_flag=1
	fi
else 
	echo "RV32I - Single Cycle Model..."
	echo ""
	vlog -f ins.list
	compile_flag=1
fi

echo ""
echo "Simulating..."
echo ""
if [[ $compile_flag == 1 ]] ; then
	vsim tb -c -do "run -all" 
fi


echo ""
echo "Script End..."
echo ""