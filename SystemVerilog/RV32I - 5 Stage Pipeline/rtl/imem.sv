/****************************************************
** imem.sv
** Author: Kai Roy, 
** Version: 1.0.0
** Date: 8/13/2024
** Description: This file defines the main interface 
** for a pipelined RISC-V core. 
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns
    
module imem(core_itf imem_if);
	logic 	[31:0] iaddr;
	wire 	[31:0] idata;

	//input
	assign iaddr = imem_if.iaddr;

	//output
	assign imem_if.idata = idata;

    logic [31:0] i_arr[0:31];
    initial begin
		$readmemb("./tb/imem1_ini.mem",i_arr);
		//$readmemh("imem5_ini.mem",i_arr);
	end

    assign idata = i_arr[iaddr[31:2]];
endmodule