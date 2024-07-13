/****************************************************
** RISC-V_I_instr.sv
** Author: Kai Roy
** Version: 1.0
** Date: 7/10/2024
** Description: This file handles the I Type instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns
import riscv_pkg::*;


module I_type(Instr_IO.I_type_io_ports bus);
	logic 		[31:0] 	out0,out1,out2,out3,out4,out5,out6,out7;
	logic 		[2:0] 	sel;
    logic 		[31:0] 	tmp1;
    logic 		[11:0] 	tmp2;
	
	wire  		[31:0] 	instr;
	wire signed [31:0] 	in1;
	logic signed[31:0] 	imm;
	wire 		[31:0] 	out;
	
	assign instr	= {bus.idata[14:12]};
	assign in1		= bus.rv1;
	assign imm		= bus.imm;

	assign bus.regdata_I = out;
	
	
    assign tmp1 = unsigned'(in1);
    assign tmp2 = unsigned'(imm);

	i_func func;
	assign func = i_func'(instr);

	// NEED TO FIGURE OUT FUNC FORMAT!!!

	// always_comb begin
	// 	unique case(func)
    //         ADDI:  	out = in1+imm;
    //         SLLI:  	out = in1<<imm[4:0];
    //         SLTI:  	out = in1<imm;
    //         SLTIU: 	out = tmp1<tmp2;
    //         XORI: 	out = in1 ^ imm;
    //         SRLI: 	out = instr[30] ? in1>>imm[4:0] : in1>>>imm[4:0]; //handles both srli + srai?
	// 		ORI:	out = in1 | imm;
	// 		ANDI:	out = in1 & imm;
	// 	    default: ;
	// 	endcase
	// end

	assign out0 = in1+imm; //addi
	assign out1 = in1<<imm[4:0]; //slli
	assign out2 = in1<imm; //slti
	assign out3 = tmp1<tmp2; //sltiu
	assign out4 = in1 ^ imm; //xori
	assign out5 = instr[30] ? in1>>imm[4:0] : in1>>>imm[4:0];   //srli || srai
	assign out6 = in1 | imm; //ori
	assign out7 = in1 & imm; //andi

	mux_3 inst1 (sel,out0,out1,out2,out3,out4,out5,out6,out7,out);

endmodule : I_type



module mux_3(
	input 	logic [2:0] 	s, 
	input 	logic [31:0] 	i0,i1,i2,i3,i4,i5,i6,i7, 
	output 	logic [31:0] 	y
);

	assign y = s[2] ? (s[1] ? (s[0] ? i7 : i6) : (s[0] ? i5 : i4 )) : (s[1] ? (s[0] ? i3 : i2) : (s[0] ? i1 : i0));

endmodule : mux_3