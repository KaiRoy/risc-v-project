
/****************************************************
** RISC-V_I_instr.sv
** Author: Sri Sai Sumanth,
** Version: 1.0
** Date: 11/21/2023
** Description: This file handles the I Type instructions and 3:1 Mux of 32 bit wide. 
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/





module I_type(
    input logic [31:0] instr,
    input signed [31:0] in1,
    input signed [31:0] imm,
    output logic  [31:0] out
);
    logic [31:0] tmp1;
    logic [11:0] tmp2;
	
	logic [31:0] out0,out1,out2,out3,out4,out5,out6,out7;
	logic [2:0] sel;
    assign tmp1 = in1;
    assign tmp2 = imm;
	assign sel= instr[14:12];

assign out0=in1+imm; //addi
assign out1=in1<<imm[4:0]; //slli
assign out2=in1<imm; //slti
assign out3=tmp1<tmp2; //sltiu
assign out4=in1 ^ imm; //xori
assign out5=instr[30] ? in1>>imm[4:0] : in1>>>imm[4:0];   //srli || srai
assign out6=in1 | imm; //ori
assign out7=in1 & imm; //andi

mux_3 inst1 (sel,out0,out1,out2,out3,out4,out5,out6,out7,out);

endmodule : I_type



module mux_3(input logic [2:0] s, input logic [31:0] i0,i1,i2,i3,i4,i5,i6,i7, output logic [31:0] y);

assign y = s[2] ? (s[1] ? (s[0] ? i7 : i6) : (s[0] ? i5 : i4 )) : (s[1] ? (s[0] ? i3 : i2) : (s[0] ? i1 : i0));

endmodule : mux3