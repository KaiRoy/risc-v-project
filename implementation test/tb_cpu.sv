// `timescale 1ns / 1ps
`timescale 1ns / 1ns
module cpu_tb;
logic clk;
logic reset;
logic [31:0] iaddr;  
logic [31:0] pc;     
logic [31:0] x31;


// Instr_IO_cpu_sig tb_connections(.clk(clk), .reset(reset), .iaddr(iaddr), .pc(pc), .x31(x31)); //clk,reset,iaddr,pc,x31

CPU ins (.*);

initial begin 
	clk = 0;
end

always #5 clk = ~clk;

initial begin
	$monitor($time, "\tx31: %d\tiaddr: %d\tpc: %d\tidata: %b", ins.x31, ins.iaddr, ins.pc, ins.instruction.idata);
	reset=1; #12;
	reset=0;
	#55
	$display($time, "\tiaddr: %d\tclk: %d\tcpu_clk: %d\tcpu_reset: %d", ins.iaddr, clk, ins.clk, ins.reset);

	#1000;
	$finish;
end

endmodule 