/****************************************************
** RISC-V_R_instr.sv
** Author: Kai Roy,
** Version: 1.0
** Date: 11/21/2023
** Description: This file handles the MULDIV instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns

import riscv_pkg::*;


module M_type(Instr_IO_cpu_sig.R_type_io_ports bus_r);	
	logic [31:0] instr;
	logic signed [31:0] rs1,rs2;
    logic [31:0] u_rs1, u_rs2;
	logic [31:0] rd;
    logic [63:0] product, product_u, product_su;
	
	//input
	assign instr=bus_r.idata;
	assign rs1=bus_r.rv1;
	assign rs2=bus_r.rv2;

	//output
	assign bus_r.regdata_R=rd;

    m_func func;
	assign func = m_func'({instr[30],instr[25],instr[14:12]});
	

    always_comb
    begin
        u_rs1 = unsigned'(rs1); // for unsigned operations 
	    u_rs2 = unsigned'(rs2);
        product = rs1 * rs2;
        product_u = u_rs1 * u_rs2;
        product_su = rs1 * u_rs2;
        unique case(func)
            MUL:    rd = product[31:0];
            MULH:   rd = product[63:32];
            MULHSU: rd = product_su[63:32];
            MULHU:  rd = product_u[63:32];
            DIV:    rd = rs1 / rs2;
            DIVU:   rd = u_rs1 / u_rs2;
            REM:    rd = rs1 % rs2;
            REMU:   rd = u_rs1 % u_rs2;
		    default: ;
        endcase
    end
endmodule : R_type