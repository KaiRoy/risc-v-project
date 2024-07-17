interface  Instr_IO (
	input 	logic 			clk,
	output 	logic [31:0] 	iaddr,	//Stores current Program counter value
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


	modport R_type_io_ports (input idata, input rv1, input rv2, output regdata_R); 
	modport I_type_io_ports (input idata, input rv1, input imm, output regdata_I);
	modport L_type_io_ports (input idata, input daddr, input drdata, output regdata_L);
	modport S_type_io_ports (input idata, input daddr, output we_S);
	modport B_type_io_ports (input idata, input iaddr, input imm, input rv1 ,input rv2 ,output iaddr_val);
	modport imem_io_ports   (input iaddr, output idata);
	modport dmem_io_ports   (input clk, input daddr, input dwdata, input we, output drdata);
	modport regfile_io_ports(input clk, input rs1, input rs2, input rd, input regdata, input wer, output rv1, output rv2, output x31);

endinterface