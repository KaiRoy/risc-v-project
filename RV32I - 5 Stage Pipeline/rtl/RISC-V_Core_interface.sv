/****************************************************
** RISC-V_Core_interface.sv
** Author: Kai Roy, 
** Version: 1.0.0
** Date: 8/13/2024
** Description: This file defines the main interface 
** for a pipelined RISC-V core. 
****************************************************/
interface  core_itf (
	input 	logic 			clk,
	input 	logic 			reset,
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
    output 	logic [31:0]  	pc,
	output 	logic [31:0] 	x31
	);
	/*************************************************************************************************************
	** Variables
	*************************************************************************************************************/
	// Flags
	logic regDst;  // This Flag seems to be unnecessary as their is no distinction between rd and rt in this implementation

	// Control Signals
	logic 	[3:0] 	we;			// write enable signal for each byte of 32-b word
	logic 			wer;
	wire 	[3:0] 	we_S;		//??Interval??

	// Main Data Variables
	logic 	[31:0] 	idata;		// data from instruction memory
	logic 	[31:0] 	daddr;		// address to data memory
	wire 	[31:0] 	drdata;		// data read from data memory reg [31:0] dwdata, // data to be written to data memory reg [4:0] rd,rs1,rs2, reg signed [31:0] imm,
	logic 	[31:0] 	dwdata;		// data to be written to data memory
	logic 	[31:0] 	regdata;

	// Interval Data Variables
	logic 	[31:0] 	regdata_R, regdata_I;	//??Interval??
	wire 	[31:0] 	regdata_L, iaddr_val;	//??Interval??

	// Address Breakdown
	logic 	[4:0] 	rd,rs1,rs2;
	logic 	[31:0] 	imm;
	
	logic signed [31:0] 	rv1, rv2;		//??Interval??


	/*************************************************************************************************************
	** Modports
	*************************************************************************************************************/
	modport R_type_io_ports (input idata, input rv1, input rv2, output regdata_R); 
	modport I_type_io_ports (input idata, input rv1, input imm, output regdata_I);
	modport L_type_io_ports (input idata, input daddr, input drdata, output regdata_L);
	modport S_type_io_ports (input idata, input daddr, output we_S);
	modport B_type_io_ports (input idata, input iaddr, input imm, input rv1 ,input rv2 ,output iaddr_val);
	modport imem_io_ports   (input iaddr, output idata);
	modport dmem_io_ports   (input clk, input daddr, input dwdata, input we, output drdata);
	modport regfile_id_ports(input clk, input rs1, input rs2, output rv1, output rv2, output x31);
	modport regfile_wb_ports(input rd, input regdata, input wer);

	
	/*************************************************************************************************************
	** Functions
	*************************************************************************************************************/
	function push (core_itf new_itf);
		// Control Signals
		we		<= new_itf.we;
		wer		<= new_itf.wer;
		we_S	<= new_itf.we_S;

		// Main Data Variables
		idata	<= new_itf.idata;
		daddr	<= new_itf.daddr;
		drdata	<= new_itf.drdata; 
		dwdata	<= new_itf.dwdata;
		regdata	<= new_itf.regdata;

		// Interval Data Variables
		regdata_R	<= new_itf.regdata_R;
		regdata_I	<= new_itf.regdata_I;
		regdata_L	<= new_itf.regdata_L;
		iaddr_val	<= new_itf.iaddr_val;

		// Address Breakdown
		rd 	<= new_itf.rd;
		rs1	<= new_itf.rs1;
		rs2	<= new_itf.rs2;
		imm	<= new_itf.imm;
		rv1 <= new_itf.rv1;
		rv2 <= new_itf.rv2;	
	endfunction

	function reset;
		
	endfunction

	function r_set;
		wer 	= 1;
		we 		= 4'b0;
		regdata	= regdata_R;
		pc 		= iaddr+4;
		regDst 	= 1;	// R Format
	endfunction

	function i_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer		= 1;
		we		= 4'b0;
		regdata = regdata_I;
		pc 		= iaddr+4;
		regDst 	= 0;	// I Format
	endfunction

	function l_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer		= 1;
		we		= 4'b0;
		daddr 	= rv1+imm;    
		regdata = regdata_L;
		pc 		= iaddr+4;
		regDst 	= 0;	// I Format
	endfunction

	function s_set;
		wer		= 0;
		daddr 	= rv1+imm;
		we 		= we_S;
		pc 		= iaddr+4;
		regDst 	= 0;	//I Format
		case(idata[14:12])
			3'b000: dwdata = {rv2[7:0], rv2[7:0], rv2[7:0], rv2[7:0]};
			3'b001: dwdata = {rv2[15:0], rv2[15:0]};
			3'b010: dwdata = rv2;
		endcase
	endfunction

	function b_set;
		imm 	= {{20{idata[31]}},idata[31],idata[7],idata[30:25],idata[11:8],1'b0};
		wer		= 0;
		we		= 4'b0;
		pc 		= iaddr_val;
		regDst 	= 1;	// ? Format !!!!!! Does it matter?
	endfunction

	function jalr_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+4;
		pc 		= (rv1+imm) & 32'hfffffffe;
		regDst 	= 1;	// ? Format !!!!!!	Does it matter?
	endfunction

	function jal_set;
		imm 	= {{11{idata[31]}},idata[31],idata[19:12],idata[20],idata[30:21],1'b0};
		pc 		= (iaddr+imm);
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+4;
		regDst 	= 1;	// ? Format !!!!!!	Does it matter?
	endfunction

	function auipc_set;
		imm 	= {idata[31:12],12'b0};
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+imm;
		pc 		= iaddr+4;
		regDst 	= 1;	// ? Format !!!!!!	Does it matter?
	endfunction

	function lui_set;
		imm 	= {idata[31:12],12'b0};
		wer		= 1;
		we		= 4'b0;
		regdata = imm;
		pc 		= instr.iaddr+4;
		regDst 	= 1;	// ? Format !!!!!!
	endfunction

endinterface