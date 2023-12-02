// `timescale 1ns / 1ps
`timescale 1ns / 1ns
//Regfile module
   
/**     input logic clk,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] regdata,
    input wer,
    output logic [31:0] rv1,
    output logic [31:0] rv2,
	output logic [31:0] x31**/
	
module regfile(Instr_IO_cpu_sig reg_if);

	logic [4:0] rs1;
	logic [4:0] rs2;
	logic [4:0] rd;
	logic [31:0] rv1;
	logic [31:0] rv2;
	logic [31:0] x31;
	logic [31:0] regdata;
	logic wer,clk;

	//output
	assign reg_if.rv1=rv1;
	assign reg_if.rv2=rv2;
	assign reg_if.x31=x31;

	//inputs
	assign clk=reg_if.clk;
	assign rs1=reg_if.rs1;
	assign rs2=reg_if.rs2;
	assign rd=reg_if.rd;
	assign regdata=reg_if.regdata;
	assign wer=reg_if.wer;


    logic [31:0] r[0:31];
    integer i;
    initial begin
		r[31] = 0;
        for(i=0; i<31; i = i+1)
            r[i]=i;
    end


    assign rv1 = r[rs1];
    assign rv2 = r[rs2];
	assign x31 = r[31];

    always@(posedge clk) 
    begin
        if(wer && (rd != 0))
            r[rd] = regdata;
    end
endmodule