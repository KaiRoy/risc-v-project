// `timescale 1ns / 1ps
`timescale 1ns / 1ns
//Regfile module
	
module regfile(core_itf.regfile_id_ports ID_itf, coreitf.regfile_wb_ports WB_itf);
	logic	[4:0] 	rs1, rs1, rd;
	logic 	[31:0] 	rv1, rv2, x31, regdata;
	logic 			wer, clk;

	// Inputs (ID)
	assign clk		= ID_itf.clk;
	assign rs1		= ID_itf.rs1;
	assign rs2		= ID_itf.rs2;

	// Inputs (WB)
	assign rd		= WB_itf.rd;
	assign regdata	= WB_itf.regdata;
	assign wer		= WB_itf.wer;

	// Outputs
	assign ID_itf.rv1 	= rv1;
	assign ID_itf.rv2 	= rv2;
	assign ID_itf.x31 	= x31;

	// Register File Structure
    logic [31:0] r[0:31];

	// Initialization
    integer i;
    initial begin
		r[31] = 0;
        for(i=0; i<31; i = i+1)
            r[i]=i;
    end

	// Read (ID Stage)
	always @(negedge clk) begin
		rv1 = r[rs1];
		rv2 = r[rs2];
		x31 = r[31];
	end

	// Write (WB Stage)
    always@(posedge clk) begin
        if(wer && (rd != 0))
            r[rd] = regdata;
    end
endmodule