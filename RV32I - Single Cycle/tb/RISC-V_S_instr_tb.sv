`timescale 1ns / 1ps
module testbench;

  // Inputs
  logic [31:0] instr;
  logic [31:0] daddr;

  // Outputs
  logic [3:0] we;

  // Instantiate the module
  S_type uut (
    .instr(instr),
    .daddr(daddr),
    .we_S(we)
  );

  // Initial block for test stimulus
  initial begin
instr = 32'b00000000000000000000000000000000;daddr=32'd1;#1;
$display("%d",we);
instr = 32'b00000000000000000010000000000000;daddr=32'd1;#1;
$display("%d",we);
instr = 32'b00000000000000000100000000000000;daddr=32'd1;#1;
$display("%d",we);
  end
$finish
endmodule
