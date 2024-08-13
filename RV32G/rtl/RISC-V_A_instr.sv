/****************************************************
** RISC-V_A_instr.sv
** Author: Kai Roy,
** Version: 1.0
** Date: 7/10/2024
** Description: This file handles the MULDIV instructions
** of a RISC-V Single Cycle Processor. (WIP)
****************************************************/
// `timescale 1ns / 1ps
`timescale 1ns / 1ns
import riscv_pkg::*;


module A_type(Instr_IO.A_type_io_ports bus);	
	logic 			[31:0] instr;
	logic signed 	[31:0] rs1,rs2;
    logic 			[31:0] u_rs1, u_rs2;
	logic 			[31:0] rd;
    logic 			[63:0] product, product_u, product_su;
	
	//input
	assign instr 	= {bus.idata[30], bus.idata[25], ibus.idatadata[14:12]};
	assign rs1		= bus.rv1;
	assign rs2		= bus.rv2;

	//output
	assign bus.regdata_R = rd;

    m_func func;
	assign func = m_func'(instr);
	

    always_comb begin
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