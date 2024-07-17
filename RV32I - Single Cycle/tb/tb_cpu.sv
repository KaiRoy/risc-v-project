
`timescale 1ns / 1ns
module tb;
logic clk;
logic reset;
logic [31:0] iaddr;  
logic [31:0] pc;     
logic [31:0] x31;


CPU ins (.*);

initial begin 
	clk = 0;
end

always #5 clk = ~clk;

initial begin
	$monitor($time, "\tx31: %d\tiaddr: %d\tpc: %d\tinstr: %b", x31, iaddr, pc, ins.instruction.idata);
	reset=1; #12;
	reset=0;
	#1000;
	display_regfile();
	display_dmem();
	display_imem();
	$finish;
end

function void display_instr();
	$display("Oder of Instructions:");
	$display("ADD");
	$display("ADDI");
	$display("LW");
	$display("SW");
	$display("BEQ");
endfunction

function void display_dmem();
	$display("\nContents of Data Memory:");
	for (int i = 0; i < 128; i+=4) begin
		$display("Addr: %d\tData: %b", i, {ins.d1_ins.m[i+3], ins.d1_ins.m[i+2], ins.d1_ins.m[i+1], ins.d1_ins.m[i]});
	end
endfunction

function void display_imem();
	$display("\nContents of instruction memory File:");
	for (int i = 0; i < 32; i++) begin
		$display("Addr: %d\tData: %b", i, ins.im2_ins.i_arr[i][i]);
	end
endfunction

function void display_regfile();
$display("\nContents of instruction reg File:");
	for (int i = 0; i < 32; i++) begin
		$display("Addr: %d\tData: %d", i, ins.r1.r[i]);
	end
endfunction

endmodule 
