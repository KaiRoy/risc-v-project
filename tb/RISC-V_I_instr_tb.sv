/****************************************************
** RISC-V_I_instr_tb.sv
** Author: Sri Sai Sumanth, 
** Version: 1.0
** Date: 11/21/2023
** Description: Testbench for the RISC-V_I_instr_tb.sv file (WIP)
****************************************************/

module tb_I_ins;

logic [31:0] instr;
int in1;
int  imm;
int  out;


I_type inst1(.*); 

initial 

begin 
instr=32'd0;in1=32'd617;imm=32'd511;#1;
$display("%d",out);
instr=32'd4096;in1=32'd989;imm=32'd295;#1;
$display("%d",out);
instr=32'd12288;in1=32'd980;imm=32'd533;#1;
$display("%d",out);
instr=32'd24576;in1=32'd679;imm=32'd91;#1;
$display("%d",out);
instr=32'd40960;in1=32'd234;imm=32'd592;#1;
$display("%d",out);
instr=32'd61440;in1=32'd503;imm=32'd746;#1;
$display("%d",out);
instr=32'd86016;in1=32'd843;imm=32'd750;#1;
$display("%d",out);
instr=32'd114688;in1=32'd949;imm=32'd372;#1;
$display("%d",out);
end

endmodule : tb_I_ins