
/****************************************************
** RISC-V_R_instr_tb.sv
** Author: Sri Sai Sumanth, 
** Version: 1.0
** Date: 11/21/2023
** Description: Testbench for the RISC-V_R_instr_tb.sv file (WIP)
****************************************************/

module tb_R_ins;
logic [31:0] instr;
int in1;
int in2;
logic [31:0] out;

//rs0=4'b0000,rs1=4'b1000,rs2=4'b0001,rs3=4'b0010,rs4=4'b0011,rs5=4'b0100,rs6=4'b0101,rs7=4'b1101,rs8=4'b0110,rs9=4'b0111

R_type ins1 (.*); 
initial begin
instr=32'd0;in1=32'd415;in2=32'd60;#1;          //add 0000
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd1073741824;in1=32'd6553;in2=32'd653;#1; //sub 1000 
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd4096;in1=32'd288;in2=32'd349;#1;      //sll '<<'0001 
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd8192;in1=32'd696;in2=32'd623;#1;     //slt '<' signed 0010 
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd12288;in1=32'd447;in2=32'd726;#1;     //sltu '<' unsigned 0011 
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd16384;in1=32'd696;in2=32'd939;#1;     //xor '^' 0100 
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd536891392;in1=32'd147;in2=32'd194;#1; // srl '>>' 0101
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd1073762304;in1=32'd848;in2=32'd325;#1;  //sra '>>>' 1101
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd20480;in1=32'd378;in2=32'd960;#1; // or '|' 0101
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});

instr=32'd28672;in1=32'd404;in2=32'd900;#1;  //and '&' 0111
$display("output --> %d instruction in bit field [30] && [14:12]--> %b",out,{instr[30],instr[14:12]});
end

endmodule : tb_R_ins