`timescale 1ns / 1ps
module cpu_tb;
logic clk;
logic reset;
logic [31:0] iaddr;  
logic [31:0]  pc;     
logic [31:0] x31;

Instr_IO_cpu_sig tb_connections(.*); //clk,reset,iaddr,pc,x31

CPU ins (tb_connections);
//clk=tb_connections.clk;

initial begin 
	clk=0;
end


always #5 clk=~clk;

initial begin
$monitor("%d %d %d",tb_connections.x31,tb_connections.iaddr,tb_connections.pc);
reset=1; #2;
reset=0; #40;

$finish;
end

endmodule 