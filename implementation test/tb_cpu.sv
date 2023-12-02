// `timescale 1ns / 1ps
`timescale 1ns / 1ns
module cpu_tb;
logic clk;
logic reset;
logic [31:0] iaddr;  
logic [31:0] pc;     
logic [31:0] x31;

Instr_IO_cpu_sig tb_connections(.*); //clk,reset,iaddr,pc,x31

CPU ins (tb_connections);
//clk=tb_connections.clk;

initial begin 
	clk=0;
end


always #5 clk=~clk;

initial begin
$monitor($time, "\tx31: %d\tiaddr: %d\tpc: %d\tidata: %b",tb_connections.x31,tb_connections.iaddr,tb_connections.pc, tb_connections.idata);
	reset=1; #12;
	reset=0;
	#50

	#1000;
	$finish;
end

endmodule 