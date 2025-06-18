/****************************************************
** RISC-V_Core.sv
** Author: Kai Roy, 
** Version: 1.0.0
** Date: 8/13/2024
** Description: This file handles the main CPU operations
** Instructions are decoded and control signals are set.
****************************************************/
`timescale 1ns / 1ns
import riscv_pkg::*;

// !!!NOTES/TO DO!!!
	// [ ] 	Q: How to handle pipeline flushing? (Branch Pipeline Logic)
	//		NOP insertion while processing Branch Instructions (No prediction, just stalls, no need for pipeline flush)
	//		NOP encoded as ADDI x0, x0, 0
	//		* Need flag for Branch instructions?
	// [X] 	Q: How to handle Program Counter/IF stage?
	//		IF_stage.iaddr = EX_stage.pc w/ data hzard check
	// [ ] 	Q: How to Verify Pipeline? (
	//		[ ] Initial - Compare with Single Cycle for output - may need some modifications to tb
	//		[ ] Later? - Output the Instruction in each stage for each clock? Output to file for later analysis/reduce CMD clutter?
	// [X] 	Q: How to Handle Hazards/NOP Insertion?
	//		[X] Hazard Detection Modules that sets flags
	//		[X] Insert NOPs and pause PC at FF - NOP encoded as ADDI x0, x0, 0
	// [ ] 	Q: Do I need to restructure Interface? Update Interface = Yes
	//		* Probably not. (I did have to expand it)
	// [X] 	Create Modules for control signals/ID Stage
	// [ ] 	Q: Change abstraction from Instruction Type Modules to lower level? 
	//		* Probably Not


module RISCV_Core (
	input 	logic 			clk,
    input 	logic 			reset,	
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
	output 	logic [31:0]  	pc,		//Stores the value that is to be assigned in the next clk cycle to Program counter
    output 	logic [31:0] 	x31
	);

	// Flags
	logic dataHazEX;
	logic dataHazME;
	logic dataHazWB

	// Clocking/PC Func?
	always_ff @(posedge clk, posedge reset) begin
        if (reset)
            IF_stage.reset(); //IF_stage.iaddr <= 0;
        else
            if (!(dataHazEX || dataHazME || dataHazWB || branchHaz))	//No Hazard
				IF_stage.iaddr <= EX_stage.pc;
			else if (branchHaz)			// Branch Hazard
				IF_stage.push(NOP);		// Will this work???
    end 


	// Pipes
	core_itf IF_stage (.*);
	core_itf ID_stage (.*);
	core_itf EX_stage (.*);
	core_itf ME_stage (.*);
	core_itf WB_stage (.*);
	
	// Set NOP
	core_itf NOP(.*);
	assign NOP.idata = {11'b0, 5'b0, 3'b000, 5'b0, 7'b0010011}	//May not work
	assign NOP.iaddr = IF_stage.iaddr;		// Will this work???
	//imm[11:0] rs1 0 0 0 rd 0 0 1 0 0 1 1

	// IF -> ID Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            ID_stage.reset();
        else
            // ID_stage <= IF_stage;		// This probably wont work, will need to create a function
			if (dataHazEX || dataHazME || dataHazWB)
				ID_stage.push(NOP);
			else
				ID_stage.push(IF_stage);
    end 

	// ID -> EX Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            EX_stage.reset();
        else
            // EX_stage <= ID_stage;
			EX_stage.push(ID_Stage);
    end 

	//EX -> ME Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            ME_stage.reset();
        else
            // ME_stage <= EX_stage;
			ME_stage.push(EX_stage);
    end 

	//ME -> WB Stage
	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            WB_stage.reset();
        else
            // WB_stage <= ME_stage;
			WB_stage.push(ME_stage);
    end 

	//	Hazard Detection Module
	haz_det hd_ins(.*);

	//IF Stage
	imem im2_ins(IF_stage.imem_io_ports);

	//ID (WB) Stage
	regfile r1  (ID_stage.regfile_id_ports, WB_stage.regfile_wb_ports); 
	instr_decode id_ins (.instr(ID_stage));

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
        case(op_code'(instr.idata[6:0]))		// Rename Opcodes to better follow the ISA Manual???
            RTYPE: 	instr.r_set(); 
            ITYPE:	instr.i_set(); 
            LTYPE:	instr.l_set(); 
            STYPE:	instr.s_set(); 
			BTYPE:	instr.b_set(); 
			JALR:	instr.jalr_set(); 
			JAL:	instr.jal_set(); 
			AUIPC:	instr.auipc_set();
			LUI: 	instr.lui_set(); 
		endcase
    end
endmodule : instr_decode


module haz_det(
	core_itf IF_stage, ID_stage, EX_stage, ME_stage, WB_stage,
	output logic dataHazEX, dataHazME, dataHazWB
	);

	// Data Hazard Detection
    always_comb begin
		// EX Hazard
		if (ID_stage.wer && (ID_stage.rd == IF_stage.rs1 || ID_stage.rd == IF_stage.rs2))
			dataHazEX = 1;
		else
			dataHazEX = 0;
		// ME Hazard
		if (EX_stage.wer && (EX_stage.rd == IF_stage.rs1 || EX_stage.rd == IF_stage.rs2)) 
			dataHazME = 1;
		else
			dataHazME = 0;
		// WB Hazard
		if (ME_stage.wer && (ME_stage.rd == IF_stage.rs1 || ME_stage.rd == IF_stage.rs2))
			dataHazWB = 1;
		else 
			dataHazWB = 0;
	end

	//Branch Hazard Detection
	always_comb begin
		// If Branch is in IF
		// If Branch is in ID
		// If Branch is in EX?
	end
endmodule : haz_det