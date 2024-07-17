/****************************************************
** CPU.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/10/2024
** Description: This file handles the main CPU operations
** Instructions are decoded and control signals are set.
****************************************************/
`timescale 1ns / 1ns
import riscv_pkg::*;

module CPU (
	input 	logic 			clk,
    input 	logic 			reset,	
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
	output 	logic [31:0]  	pc,		//Stores the value that is to be assigned in the next clk cycle to Program counter
    output 	logic [31:0] 	x31
	);

	Instr_IO instr (.*);

	always_ff @(posedge instr.clk, posedge instr.reset) begin
        if (instr.reset)       //Other functions for reset ????
            instr.iaddr <= 0;
        else
            instr.iaddr <= instr.pc;
    end 

    always_comb  begin
		instr.rd 	= instr.idata[11:7];
		instr.rs1 	= instr.idata[19:15];
		instr.rs2 	= instr.idata[24:20];
        case(op_code'(instr.idata[6:0]))
            RTYPE: 	instr.r_set(); 
            ITYPE:	instr.i_set(); 
            LTYPE:	instr.L_set(); 
            STYPE:	instr.s_set(); 
			BTYPE:	instr.b_set(); 
			JALR:	instr.jalr_set(); 
			JAL:	instr.jal_set(); 
			AUIPC:	instr.auipc_set();
			LUI: 	instr.lui_set(); 
		endcase
    end

	// Instruction Modules
	R_type r_ins (instr.R_type_io_ports);
	I_type i_ins (instr.I_type_io_ports);
	L_type l_ins (instr.L_type_io_ports);
	S_type s_ins (instr.S_type_io_ports);
	B_type b_ins (instr.B_type_io_ports);

	// Memory
	imem im2_ins(instr.imem_io_ports);
	dmem d1_ins (instr.dmem_io_ports);
	regfile r1  (instr.regfile_io_ports);

endmodule