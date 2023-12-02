/****************************************************
** RISC-V_R_instr.sv
** Author: Sri Sai Sumanth,
** Version: 1.0
** Date: 11/21/2023
** Description: This file handles the R Type instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns

import riscv_pkg::*;


module R_type(Instr_IO_cpu_sig.R_type_io_ports bus_r);
    
    logic  [31:0] tmp1;
    logic  [31:0] tmp2; 
	
	logic [31:0] instr;
	logic signed [31:0] in1,in2;
	logic [31:0] out;
	
	//input
	assign instr=bus_r.idata;
	assign in1=bus_r.rv1;
	assign in2=bus_r.rv2;

	//output
	assign bus_r.regdata_R=out;
	//assign out=in1+in2;
	

    always_comb
    begin
		tmp1 = unsigned'(in1); // for unsigned operations 
		tmp2 = unsigned'(in2);
		//out=in1+in2;
        unique if ({instr[30],instr[14:12]}==rs0) out = in1+in2;          //add
        else if ({instr[30],instr[14:12]}==rs1)  out = in1-in2;          //sub
        else if ({instr[30],instr[14:12]}==rs2)  out = in1<<in2[4:0];	  //sll
        else if ({instr[30],instr[14:12]}==rs3)  out = in1<in2;          //slt
        else if ({instr[30],instr[14:12]}==rs4)  out = tmp1<tmp2;        //sltu
        else if ({instr[30],instr[14:12]}==rs5)  out = in1^in2;          //xor
        else if ({instr[30],instr[14:12]}==rs6)  out = in1>>in2[4:0];    //srl
        else if ({instr[30],instr[14:12]}==rs7)  out = in1>>>in2[4:0];   //sra
        else if ({instr[30],instr[14:12]}==rs8)  out = in1|in2;          //or
        else if ({instr[30],instr[14:12]}==rs9)  out = in1&in2;          //and
		else ;
        
    end
endmodule : R_type