	/**interface signal_interface_cpu(input clk,
    input reset,
	output logic [31:0] iaddr,  //Stores current Program counter value
	output logic [31:0]  pc,     //Stores the value that is to be assigned in the next clk cycle to Program counter
    output logic [31:0] x31);
	 
endinterface **/

interface  Instr_IO_cpu_sig (input logic clk,
    input logic reset,
	output logic [31:0] iaddr,  //Stores current Program counter value
	output logic [31:0]  pc,     //Stores the value that is to be assigned in the next clk cycle to Program counter
    output logic [31:0] x31);
	 logic [3:0] we;     // write enable signal for each byte of 32-b word
	 logic wer;
	 wire [31:0] regdata_R, regdata_I;
	 wire [31:0] regdata_L, iaddr_val;
     wire [3:0] we_S;
     logic [31:0] idata;   // data from instruction memory
     logic [31:0] daddr;  // address to data memory
     wire [31:0] drdata;  // data read from data memory reg [31:0] dwdata, // data to be written to data memory reg [4:0] rd,rs1,rs2, reg signed [31:0] imm,
	 logic [31:0] rv1, rv2;
	 logic [31:0] regdata;
	 logic [31:0] dwdata; // data to be written to data memory
	 logic [4:0] rd,rs1,rs2;
	 logic [31:0] imm;


modport R_type_io_ports (input idata, input  rv1, input  rv2, output regdata_R); 
modport I_type_io_ports (input idata, input rv1, input imm, output regdata_I);
modport L_type_io_ports (input idata, input daddr, input drdata, output regdata_L);
modport S_type_io_ports (input idata, input daddr, output we_S);
modport B_type_io_ports (input idata, input iaddr, input imm, input rv1 ,input rv2 ,output iaddr_val);
modport imem_io_ports   (input iaddr, output idata);
modport dmem_io_ports   (input clk,input daddr,input dwdata,input we,output drdata);
modport regfile_io_ports(input clk,input rs1,input rs2,input rd,input regdata,input wer, output rv1,output rv2,output x31);



endinterface



package Ins_def;

enum logic [3:0] {rs0=4'b0000,rs1=4'b1000,rs2=4'b0001,rs3=4'b0010,rs4=4'b0011,rs5=4'b0100,rs6=4'b0101,rs7=4'b1101,rs8=4'b0110,rs9=4'b0111} OP_CODE_R;

/**
7'b0110011 R-type
7'b0010011 I-type
7'b0000011 L-type
7'b0100011 S-type
7'b1100011 B-type
7'b1100111 JALR instruction
7'b1101111 JAL instruction
7'b0010111 AUIPC instruction
7'b0110111 LUI instruction
**/

enum logic [6:0] {R_type=7'b0110011,I_type=7'b0010011,L_type=7'b0000011,S_type=7'b0100011,B_type=7'b1100011,JALR_ins=7'b1100111,JAL_ins=7'b1101111,AUIPC_ins=7'b0010111,LUI_ins=7'b0110111} types;

endpackage