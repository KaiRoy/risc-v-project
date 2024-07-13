/****************************************************
** RISC-V_B_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/13/2024
** Description: Testbench for the RISC-V_B_instr.sv file (WIP)
****************************************************/
`timescale 1ns / 1ps
import riscv_pkg::*;

module tb;
	
	
	// Inputs
	logic [31:0] instr;
	logic [31:0] daddr;

	// Outputs
	logic [3:0] we;



	// Instantiate the module
	S_type iDUT (bus.S_type_io_ports);

	// Initial block for test stimulus
	initial begin
		instr = 32'b00000000000000000000000000000000;
		daddr=32'd1;
		#1;

		$display("%d",we);
		instr = 32'b00000000000000000010000000000000;
		daddr=32'd1;
		#1;

		$display("%d",we);
		instr = 32'b00000000000000000100000000000000;
		daddr=32'd1;
		#1;

		$display("%d",we);

		#5; $finsih;
	end
	$finish
endmodule : tb
