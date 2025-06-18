/****************************************************
** dmem.sv
** Author: Kai Roy, 
** Version: 1.0.0
** Date: 8/13/2024
** Description: This file defines the main interface 
** for a pipelined RISC-V core. 
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns
    
module dmem(Instr_IO dmem_if);
	logic 			clk;
	logic	[31:0] 	daddr;
	logic 	[31:0] 	dwdata;
	logic 	[3:0] 	we;
	wire 	[31:0] 	drdata;
 
	//input
	assign clk		= dmem_if.clk;
	assign daddr	= dmem_if.daddr;
	assign dwdata	= dmem_if.dwdata;
	assign we		= dmem_if.we;

	//output
	assign dmem_if.drdata=drdata;

	logic 	[7:0] 	m [0:127];
	wire 	[31:0] 	add0,add1,add2,add3;
	initial $readmemb("./tb/dmem_ini.mem",m);

	assign add0 = (daddr & 32'hfffffffc)+ 32'h00000000;
	assign add1 = (daddr & 32'hfffffffc)+ 32'h00000001;
	assign add2 = (daddr & 32'hfffffffc)+ 32'h00000002;
	assign add3 = (daddr & 32'hfffffffc)+ 32'h00000003;
	
	assign drdata = {m[add3], m[add2], m[add1], m[add0]};
	
	always @(posedge clk) begin
		if(we[0]==1)
			m[add0] <= dwdata[7:0];
		if(we[1]==1)
			m[add1] <= dwdata[15:8];
		if(we[2]==1)
			m[add2] <= dwdata[23:16];
		if(we[3]==1)
			m[add3] <= dwdata[31:24];
	end
endmodule