/****************************************************
** RISC-V_S_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/17/2024
** Description: Testbench for the RISC-V_B_instr.sv file (WIP)
****************************************************/
`timescale 1ns / 1ps
import riscv_pkg::*;

module tb;
	// Base Vars
	logic clk;
	logic reset;
	logic [31:0] iaddr;  
	logic [31:0] pc;     
	logic [31:0] x31;

	// Inputs
    reg [31:0] idata;
	logic [31:0] daddr;

	// Outputs
	logic [3:0] we;

	// Interface
    Instr_IO bus(.*);

	// Aliases
    assign bus.idata = idata;
    assign bus.iaddr = iaddr;
	assign bus.daddr = daddr;

    assign we = bus.we_S;

	s_func func;
	assign func = s_func'({bus.idata[30], bus.idata[25], bus.idata[14:12]});


	// Instantiate the module
	S_type iDUT (bus.S_type_io_ports);

	// Display System
    function void display_state;
        $display("Instruction: %0s\nwe = %4b\n", 
        func.name(), we);
    endfunction
    function void display_b_txt(string str);
        $display("\n%c[1;34m",27);
        $write(str);
        $display("%c[0m\n",27);
    endfunction
	function void display_pass(string str);
		$write("%c[1;31m",27);
        $write(str);
        $write("%c[0m\n\n",27);
	endfunction

	
	// Stimulus Block
	initial begin			//!!! VERIFY WHAT THE OUTPUT SHOULD BE
		#10; //SB
		$cast({idata[30], idata[25], idata[14:12]}, SB);
		daddr = 1;
		#1;
		display_state;
		if (we == 0010)
			display_pass("PASS");
		else 
			display_pass("FAIL");
		
		#10; //SH
		$cast({idata[30], idata[25], idata[14:12]}, SH);
		daddr = 0;
		#1;
		display_state;
		if (we == 0011)
			display_pass("PASS");
		else 
			display_pass("FAIL");
		
		#10; //SW
		$cast({idata[30], idata[25], idata[14:12]}, SW);
		daddr = 1;
		#1;
		display_state;
		if (we == 1111)
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#5; $finish;
	end
endmodule : tb