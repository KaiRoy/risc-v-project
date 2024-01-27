/****************************************************
** RISC-V_R_instr.sv
** Author: Kai Roy,
** Version: 1.0
** Date: 11/21/2023
** Description: This file handles the R Type instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns

import riscv_pkg::*;


module R_type(Instr_IO_cpu_sig.R_type_io_ports bus_r);	
	logic [31:0] instr;
	logic signed [31:0] rs1,rs2;
    logic [31:0] u_rs1, u_rs2;
	logic [31:0] rd;
	
	//input
	assign instr=bus_r.idata;
	assign rs1=bus_r.rv1;
	assign rs2=bus_r.rv2;

	//output
	assign bus_r.regdata_R=rd;

    r_func func;
	assign func = r_func'({instr[30],instr[25],instr[14:12]});
	

    always_comb
    begin
		u_rs1 = unsigned'(rs1); // for unsigned operations 
		u_rs2 = unsigned'(rs2);
		
        unique case(func)
            ADD:  rd = rs1+rs2;             //add
            SUB:  rd = rs1-rs2;            //sub
            SLL:  rd = rs1<<rs2[4:0];      //sll
            SLT:  rd = rs1<rs2;            //slt
            SLTU: rd = u_rs1<u_rs2;          //sltu
            XOR:  rd = rs1^rs2;            //xor
            SRL:  rd = rs1>>rs2[4:0];      //srl
            SRA:  rd = rs1>>>rs2[4:0];     //sra
            OR:   rd = rs1|rs2;            //or
            AND:  rd = rs1&rs2;            //and
		    default ;
        endcase
    end
endmodule : R_type