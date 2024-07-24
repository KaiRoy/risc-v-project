interface  core_itf (
	input 	logic 			clk,
	input 	logic 			reset,
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
    output 	logic [31:0]  	pc,
	output 	logic [31:0] 	x31
	);

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

	// Module Ports
	modport R_type_io_ports (input idata, input rv1, input rv2, output regdata_R); 
	modport I_type_io_ports (input idata, input rv1, input imm, output regdata_I);
	modport L_type_io_ports (input idata, input daddr, input drdata, output regdata_L);
	modport S_type_io_ports (input idata, input daddr, output we_S);
	modport B_type_io_ports (input idata, input iaddr, input imm, input rv1 ,input rv2 ,output iaddr_val);
	modport imem_io_ports   (input iaddr, output idata);
	modport dmem_io_ports   (input clk, input daddr, input dwdata, input we, output drdata);
	modport regfile_id_ports(input clk, input rs1, input rs2, output rv1, output rv2, output x31);
	modport regfile_wb_ports(input rd, input regdata, input wer);

	// Functions
	function reset;
		
	endfunction

	function r_set;
		wer 	= 1;
		we 		= 4'b0;
		regdata	= regdata_R;
		pc 		= iaddr+4;
	endfunction

	function i_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer		= 1;
		we		= 4'b0;
		regdata = regdata_I;
		pc 		= iaddr+4;
	endfunction

	function l_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer		= 1;
		we		= 4'b0;
		daddr 	= rv1+imm;    
		regdata = regdata_L;
		pc 		= iaddr+4;
	endfunction

	function s_set;
		wer		= 0;
		daddr 	= rv1+imm;
		we 		= we_S;
		pc 		= iaddr+4;
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
	endfunction

	function jalr_set;
		imm 	= {{20{idata[31]}},idata[31:20]};
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+4;
		pc 		= (rv1+imm) & 32'hfffffffe;
	endfunction

	function jal_set;
		imm 	= {{11{idata[31]}},idata[31],idata[19:12],idata[20],idata[30:21],1'b0};
		pc 		= (iaddr+imm);
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+4;
	endfunction

	function auipc_set;
		imm 	= {idata[31:12],12'b0};
		wer 	= 1;
		we 		= 4'b0;
		regdata = iaddr+imm;
		pc 		= iaddr+4;
	endfunction

	function lui_set;
		imm 	= {idata[31:12],12'b0};
		wer		= 1;
		we		= 4'b0;
		regdata = imm;
		pc 		= instr.iaddr+4;	
	endfunction

endinterface