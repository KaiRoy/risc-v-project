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

module RISCV_Core (
	input 	logic 			clk,
    input 	logic 			reset,	
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
	output 	logic [31:0]  	pc,		//Stores the value that is to be assigned in the next clk cycle to Program counter
    output 	logic [31:0] 	x31
	);

	// !!!NOTES/TO DO!!!
	// [ ] 	Q: How to handle pipeline flushing?
	//		Branch Pipeline Logic (NOP insertion while processing Branch Instructions) 
	// [ ] 	Q: How to handle Program Counter/IF stage?
	//		* Currently Unknown
	// [ ] 	Q: How to Verify Pipeline? (
	//		Initial - Compare with Single Cycle for output
	//		Later? - Output the Instruction in each stage for each clock? Output to for later analysis/reduce CMD clutter?
	// [ ] 	Q: How to Handle Hazards/NOP Insertion?
	//		Hazard Detection Modules with NOP Insertion
	//		* Which stage (IF or ID)?
	// [ ] 	Q: Do I need to restructure Interface? 	
	//		* Probably not.
	// [ ] 	Create Modules for control signals/ID Stage
	// [ ] 	Q: Change abstraction from Instruction Type Modules to lower level? 
	//		* Probably Not


	logic regDst;


	// Clocking/PC Func?
	always_ff @(posedge clk, posedge reset) begin
        if (reset)
            IF_stage.reset(); //IF_stage.iaddr <= 0;
        else
            IF_stage.iaddr <= IF_stage.pc;		// How to Handle?
    end 


	// Pipes
	core_itf IF_stage (.*);
	core_itf ID_stage (.*);
	core_itf EX_stage (.*);
	core_itf ME_stage (.*);
	core_itf WB_stage (.*);

	// IF -> ID Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            ID_stage.reset();
        else
            ID_stage <= IF_stage;
    end 

	// ID -> EX Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            EX_stage.reset();
        else
            EX_stage <= ID_stage;
    end 

	//EX -> ME Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            ME_stage.reset();
        else
            ME_stage <= EX_stage;
    end 

	//ME -> WB Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            WB_stage.reset();
        else
            WB_stage <= ME_stage;
    end 

	//	Hazard Detection Module
	haz_det hd_ins (.instr(ID_stage));

	//IF Stage
	imem im2_ins(IF_stage.imem_io_ports);

	//ID (WB) Stage
	regfile r1  (ID_stage.regfile_id_ports, WB_stage.regfile_wb_ports); 
	instr_decode id_ins (.*);

	// EX Stage
	R_type r_ins (EX_stage.R_type_io_ports);
	I_type i_ins (EX_stage.I_type_io_ports);
	L_type l_ins (EX_stage.L_type_io_ports);
	S_type s_ins (EX_stage.S_type_io_ports);
	B_type b_ins (EX_stage.B_type_io_ports);

	// ME Stage
	dmem d1_ins (ME_stage.dmem_io_ports);

endmodule : RISCV_Core


module instr_decode (core_itf instr);
	always_comb  begin
		instr.rd 	= instr.idata[11:7];
		instr.rs1 	= instr.idata[19:15];
		instr.rs2 	= instr.idata[24:20];
        case(op_code'(instr.idata[6:0]))
            RTYPE: 	instr.r_set(); 
            ITYPE:	instr.i_set(); 
            LTYPE:	instr.l_set(); 
            STYPE:	instr.s_set(); 
			BTYPE:	instr.b_set(); 
			JALR:	instr.jalr_set(); 
			JAL:	instr.jal_set(); 
			AUIPC:	instr.auipc_set();
			LUI: 	instr.lui_set(); 
			NOP: 	;
		endcase
    end
endmodule : instr_decode


module haz_det(
	core_itf IF_stage, ID_stage, EX_stage, ME_stage, WB_stage
	//Inputs/Outputs?
	);
    //insert internal vars, 

    //Alias
    // assign instr	= bus.idata[14:12];
    // assign iaddr 	= bus.iaddr;
    // assign imm 		= bus.imm;
    // assign rs1 		= bus.rv1;
    // assign rs2 		= bus.rv2;

    // assign bus.iaddr_val = pc;

	// Hazard Detection Logic
    always_comb begin
		// EX Hazard
			// ID RegWrite && (All Reg Combos)
		// ME Hazard
			// EX RegWrite && ((EX WriteReg && IF ReadReg1) || (EX WriteReg && IF ReadReg2))
		// WB Hazard
			// ME RegWrite && ((ME WriteReg && IF ReadReg1) || (ME WriteReg && IF ReadReg2))			//Need if doing half clk cycle regfile?
	end
endmodule : haz_det