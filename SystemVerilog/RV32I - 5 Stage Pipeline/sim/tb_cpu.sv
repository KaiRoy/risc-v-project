/****************************************************
** tb_cpu.sv
** Author: Kai Roy, 
** Version: 1.0.0
** Update Date: 8/13/2024
** Description: This file handles the main CPU operations
** Instructions are decoded and control signals are set.
****************************************************/
`timescale 1ns / 1ns
import riscv_pkg::*;

module tb;
	// Core Inputs
	logic clk;
	logic reset;

	// Core Outputs
	logic [31:0] iaddr;  
	logic [31:0] pc;     
	logic [31:0] x31;

	// Core instantiation
	RISCV_Core iDUT (.*);

	// clock generation for core
	always #5 clk = ~clk;
	initial begin 
		clk = 0;
	end

	// Testbench Stimulus
	initial begin
		$monitor($time, "\tx31: %d\tiaddr: %d\tpc: %d\tinstr: %b", x31, iaddr, pc, iDUT.instr.idata);
		reset=1; #12;
		reset=0;
		#1000;
		display_regfile();
		display_dmem();
		display_imem();
		$finish;
	end


	/*************************************************************************************************************
	** Functions
	*************************************************************************************************************/
	/****************************************************************************
	** Function: display_pipe
	** Description: Display the current state of the pipeline i.e. which instruction
	** is in what stage of the pipeline. 
	****************************************************************************/
	function void display_pipe();

	endfunction

	/****************************************************************************
	** Function: display_dmem
	** Description: Display the current state of the data memory
	****************************************************************************/
	function void display_dmem();
		$display("\nContents of Data Memory:");
		for (int i = 0; i < 128; i+=4) begin
			$display("Addr: %d\tData: %b", i, {iDUT.d1_ins.m[i+3], iDUT.d1_ins.m[i+2], iDUT.d1_ins.m[i+1], iDUT.d1_ins.m[i]});
		end
	endfunction

	/****************************************************************************
	** Function: display_imem
	** Description: Display the current state of the instruction memeory
	****************************************************************************/
	function void display_imem();
		$display("\nContents of instruction memory File:");
		for (int i = 0; i < 32; i++) begin
			$display("Addr: %d\tData: %b", i, iDUT.im2_ins.i_arr[i][i]);
		end
	endfunction

	/****************************************************************************
	** Function: display_regfile
	** Description: Display the current state of the register file
	****************************************************************************/
	function void display_regfile();
	$display("\nContents of instruction reg File:");
		for (int i = 0; i < 32; i++) begin
			$display("Addr: %d\tData: %d", i, iDUT.r1.r[i]);
		end
	endfunction
endmodule 