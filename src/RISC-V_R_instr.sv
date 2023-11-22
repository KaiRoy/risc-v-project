
/****************************************************
** RISC-V_R_instr.sv
** Author: Sri Sai Sumanth,
** Version: 1.0
** Date: 11/21/2023
** Description: This file handles the R Type instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/

import rs_opcode::*;


module R_type(
    input logic [31:0] instr,
    input signed  [31:0] in1,
    input signed  [31:0] in2,
    output logic [31:0] out
);
    logic  [31:0] tmp1;
    logic  [31:0] tmp2; 

    always_comb
    begin
		tmp1 = in1; // for unsigned operations 
		tmp2 = in2;
        unique if ({instr[30],instr[14:12]}==rs0)       out = in1+in2;          //add
        else if ({instr[30],instr[14:12]}==rs1)  out = in1-in2;          //sub
        else if ({instr[30],instr[14:12]}==rs2)  out = in1<<in2[4:0];	  //sll
        else if ({instr[30],instr[14:12]}==rs3)  out = in1<in2;          //slt
        else if ({instr[30],instr[14:12]}==rs4)  out = tmp1<tmp2;        //sltu
        else if ({instr[30],instr[14:12]}==rs5)  out = in1^in2;          //xor
        else if ({instr[30],instr[14:12]}==rs6)  out = in1>>in2[4:0];    //srl
        else if ({instr[30],instr[14:12]}==rs7)  out = in1>>>in2[4:0];   //sra
        else if ({instr[30],instr[14:12]}==rs8)  out = in1|in2;          //or
        else if ({instr[30],instr[14:12]}==rs9)  out = in1&in2;          //and
        
    end
endmodule : R_type