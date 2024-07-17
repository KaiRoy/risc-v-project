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
            RTYPE: 	r_set(instr);
            ITYPE:	i_set(instr);
            LTYPE:	l_set(instr);
            STYPE:	s_set(instr);
			BTYPE:	b_set(instr);
			JALR:	jalr_set(instr);
			JAL:	jal_set(instr);
			AUIPC:	auipc_set(instr);
			LUI: 	lui_set(instr);
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


	// Functions
	function void r_set;
		instr.wer 		= 1;
		instr.we 		= 4'b0;
		instr.regdata 	= instr.regdata_R;
		instr.pc 		= instr.iaddr+4;
	endfunction	

	function void i_set(
		inout Instr_IO_cpu_sig instr);
		instr.imm 		= {{20{instr.idata[31]}},instr.idata[31:20]};
		instr.wer		= 1;
		instr.we		= 4'b0;
		instr.regdata 	= instr.regdata_I;
		instr.pc 		= instr.iaddr+4;
	endfunction	

	function void l_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {{20{instr.idata[31]}},instr.idata[31:20]};
		instr.wer		= 1;
		instr.we		= 4'b0;
		instr.daddr 	= instr.rv1+instr.imm;    
		instr.regdata 	= instr.regdata_L;
		instr.pc 		= instr.iaddr+4;
	endfunction	

	function void s_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {{20{instr.idata[31]}},instr.idata[31:25],instr.idata[11:7]};
		instr.wer		= 0;
		instr.daddr 	= instr.rv1+instr.imm;
		instr.we 		= instr.we_S;
		instr.pc 		= instr.iaddr+4;
		case(instr.idata[14:12])
			3'b000: instr.dwdata = {instr.rv2[7:0],instr.rv2[7:0],instr.rv2[7:0],instr.rv2[7:0]};
			3'b001: instr.dwdata = {instr.rv2[15:0],instr.rv2[15:0]};
			3'b010: instr.dwdata = instr.rv2;
		endcase
	endfunction	

	function void b_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {{20{instr.idata[31]}},instr.idata[31],instr.idata[7],instr.idata[30:25],instr.idata[11:8],1'b0};
		instr.wer		= 0;
		instr.we		= 4'b0;
		instr.pc 		= instr.iaddr_val;
	endfunction	

	function void jalr_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {{20{instr.idata[31]}},instr.idata[31:20]};
		instr.wer 		= 1;
		instr.we 		= 4'b0;
		instr.regdata 	= instr.iaddr+4;
		instr.pc 		= (instr.rv1+instr.imm) & 32'hfffffffe;
	endfunction

	function void jal_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {{11{instr.idata[31]}},instr.idata[31],instr.idata[19:12],instr.idata[20],instr.idata[30:21],1'b0};
		instr.pc 		= (instr.iaddr+instr.imm);
		instr.wer 		= 1;
		instr.we 		= 4'b0;
		instr.regdata 	= instr.iaddr+4;
	endfunction

	function void auipc_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {instr.idata[31:12],12'b0};
		instr.wer 		= 1;
		instr.we 		= 4'b0;
		instr.regdata 	= instr.iaddr+instr.imm;
		instr.pc 		= instr.iaddr+4;
	endfunction

	function void lui_set(
		inout Instr_IO_cpu_sig instr
		);
		instr.imm 		= {instr.idata[31:12],12'b0};
		instr.wer		= 1;
		instr.we		= 4'b0;
		instr.regdata 	= instr.imm;
		instr.pc 		= instr.iaddr+4;
	endfunction

endmodule