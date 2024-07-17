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
    logic [2:0] instr;
	logic signed [31:0] rs1, imm, rd;
	logic [31:0] u_rs1, u_imm;
	
	assign instr	= {bus.idata[14:12]};
	assign rs1		= bus.rv1;
	assign imm		= bus.imm;

	assign bus.regdata_I = rd;
	
	
    assign u_rs1 = unsigned'(rs1);
    assign u_imm = unsigned'(imm);

	i_func func;
	assign func = i_func'(instr);

	always_comb begin
		unique case(func)
            ADDI:  	rd = rs1+imm;
            SLTI:  	rd = rs1<imm;
            SLTIU: 	rd = u_rs1<u_imm;
            XORI: 	rd = rs1 ^ imm;
			ORI:	rd = rs1 | imm;
			ANDI:	rd = rs1 & imm;
			SLLI:  	rd = rs1<<imm[4:0];
            SRLI: 	rd = bus.idata[30] ? (rs1>>>imm[4:0]) : (rs1>>imm[4:0]) // if bus.idata[30] is 1 then SRAI else SRLI
		    default: ;
		endcase

		if (func == SRLI) begin
			$display("Internal Expected = %32b\n", rs1>>>imm[4:0]);
			$display("Internal Actual = %32b\n", rd);
		end
	end

endmodule : I_type