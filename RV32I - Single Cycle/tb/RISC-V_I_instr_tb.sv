/****************************************************
** RISC-V_I_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/13/2024
** Description: Testbench for the RISC-V_I_instr_tb.sv file (WIP)
****************************************************/
`timescale 1ns / 1ns
import riscv_pkg::*;

module tb;
	// Base Vars
	logic clk;
	logic reset;
	logic [31:0] iaddr;  
	logic [31:0] pc;     
	logic [31:0] x31;

    // Inputs
    reg [31:0] idata;
    logic signed [31:0] imm, rv1, rv2;

    // Outputs
    logic [31:0] iaddr_val;

	// Interface
    Instr_IO bus(.*);

	// Aliases
    assign bus.idata = idata;
    assign bus.iaddr = iaddr;
    assign bus.imm = imm;
    assign bus.rv1 = rv1;
    assign bus.rv2 = rv2;

    assign rd = bus.regdata_I;

	i_func func;
	assign func = i_func'(bus.idata[14:12]);

	// Instantiate the module
	I_type iDUT(bus.I_type_io_ports); 

	// Display System
    function void display_state;
        $display("Instruction: %0s\nrv1 = %d\timm = %d\nrd: %d\n", 
        func.name(), rv1, imm, rd);
    endfunction
    function void display_b_txt(string str);
        $display("\n%c[1;34m",27);
        $write(str);
        $display("%c[0m\n",27);
    endfunction
	function void display_pass(string str);
		$write("%c[1;31m",27);
        $write(str);
        $write("%c[0m\n\n",27);
	endfunction

	initial begin 
		#10 //ADDI
		display_b_txt("Test 1: ADDI");
		$cast({idata[14:12]}, ADDI);
		rv1=32'd617;
		imm=32'd511;
		#1 display_state();
		if (rd == (rv1 + imm))
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#10 //SLTI
		display_b_txt("Test 2: SLTI");
		$cast({idata[14:12]}, SLTI);
		rv1=32'd989;
		imm=32'd295;
		#1 display_state();
		if (rd == (rv1 < imm))
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#10 //SLTIU
		display_b_txt("Test 3: SLTIU");
		$cast({idata[14:12]}, SLTIU);
		rv1=32'd980;
		imm=32'd533;
		#1 display_state();
		if (rd == (unsigned'(rv1) < unsigned'(imm)))
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#10 //XORI
		display_b_txt("Test 4: XORI");
		$cast({idata[14:12]}, XORI);
		rv1=32'd679;
		imm=32'd91;
		#1 display_state();
		if (rd == (rv1 ^ imm))
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#10 //ORI
		display_b_txt("Test 5: ORI");
		$cast({idata[14:12]}, ORI);
		rv1=32'd234;
		imm=32'd592;
		#1 display_state();
		if (rd == (rv1 | imm))
			display_pass("PASS");
		else 
			display_pass("FAIL");
		
		#10 //ANDI
		display_b_txt("Test 6: ANDI");
		$cast({idata[14:12]}, ANDI);
		rv1=32'd503;
		imm=32'd746;
		#1;
		
		#10 //SLLI
		display_b_txt("Test 7: SLLI");
		$cast({idata[14:12]}, SLLI);
		rv1=32'd843;
		imm=32'd750;
		#1 display_state();
		if (rd == (rv1 << imm[4:0]))
			display_pass("PASS");
		else 
			display_pass("FAIL");
		
		#10 //SRLI
		display_b_txt("Test 8: SRLI");
		$cast({idata[14:12]}, SRLI);
		rv1=32'd949;
		imm=32'd372;
		idata[30] = 0;
		#1 display_state();
		if (rd == (rv1 >> imm[4:0]))
			display_pass("PASS");
		else 
			display_pass("FAIL");
		
		#10 //SRAI
		display_b_txt("Test 9: SRAI");
		$cast({idata[14:12]}, SRLI);
		rv1=32'd949;
		imm=32'd372;
		idata[30] = 1;
		#1 display_state();
		if (rd == (rv1 >>> imm[4:0]))
			display_pass("PASS");
		else 
			display_pass("FAIL");

		#5
		$finish;
	end

endmodule : tb