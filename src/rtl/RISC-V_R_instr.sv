/****************************************************
** RISC-V_R_instr.sv
** Author: Kai Roy,
** Version: 1.0
** Date: 7/10/2024
** Description: This file handles the R Type instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns
import riscv_pkg::*;


module R_type(Instr_IO_cpu_sig.R_type_io_ports bus);	
	logic [31:0] instr;
	logic signed [31:0] rs1,rs2;
    logic [31:0] u_rs1, u_rs2;
	logic [31:0] rd;
	
	//input
	assign instr	= {bus.idata[30], bus.idata[25], bus.idata[14:12]};
	assign rs1		= bus.rv1;
	assign rs2		= bus.rv2;

	//output
	assign bus.regdata_R = rd;

    r_func func;
	assign func = r_func'(instr);
	

    always_comb
    begin
		u_rs1 = unsigned'(rs1); // for unsigned operations 
		u_rs2 = unsigned'(rs2);
		
        unique case(func)
            ADD:  rd = rs1+rs2;
            SUB:  rd = rs1-rs2;
            SLL:  rd = rs1<<rs2[4:0];
            SLT:  rd = rs1<rs2;
            SLTU: rd = u_rs1<u_rs2;
            XOR:  rd = rs1^rs2;
            SRL:  rd = rs1>>rs2[4:0];
            SRA:  rd = rs1>>>rs2[4:0];
            OR:   rd = rs1|rs2;
            AND:  rd = rs1&rs2;
		    default ;
        endcase
    end
endmodule : R_type