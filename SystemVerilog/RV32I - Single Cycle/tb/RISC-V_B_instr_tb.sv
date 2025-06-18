/****************************************************
** RISC-V_B_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/13/2024
** Description: Testbench for the RISC-V_B_instr.sv file
****************************************************/
`timescale 1ns / 1ps
import riscv_pkg::*;

module tb();
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

    assign iaddr_val = bus.iaddr_val;

    // Variables
    b_func branch;
    assign branch = b_func'(idata[14:12]);

    // Instantiate the module
    B_type iDUT(bus.B_type_io_ports);

    // Display System
    function void display_state;
        $display("Current PC: %8h\nBranch Instruction: %0s\nimm = %h\trv1 = %d\trv2 = %d\nNext PC: %8h\n", 
        iaddr, branch.name(), imm, rv1, rv2, iaddr_val);
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


    // Initial Values
    initial begin
        iaddr   = 0;
        imm     = 'hFF;
        idata   = 0;
        rv1     = 0;
        rv2     = 0;
    end

    // Test Stimulus
    initial begin
        #10;
        display_b_txt("Test 1: BEQ");	// Testing BEQ
        $cast(idata[14:12], BEQ);		// Set instruction and registers
        rv1 = 10;
        rv2 = 10;
        #1 display_state();				// Display Current State/Results
		if (imm == iaddr_val)			// Result should be equal
			display_pass("PASS");		
		else 
			display_pass("FAIL");
		
        #10
        rv1 = 5;						// Set new register values
        #1 display_state();				// Display Current State/Results
		if (imm != iaddr_val)			// Result should NOT be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");


        #5;
        display_b_txt("Test 2: BNE");	// Testing BNE
        $cast(idata[14:12], BNE);		// Set instruction and registers
        rv1 = 10;
        rv2 = 10;
        #1 display_state();				// Display Current State/Results
		if (imm != iaddr_val)			// Result should NOT be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");
        #10
        rv1 = 5;						// Set new register values
        #1 display_state();				// Display Current State/Results
		if (imm == iaddr_val)			// Result should be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");


        #5;
        display_b_txt("Test 3: BLT");	// Testing BLT
        $cast(idata[14:12], BLT);		// Set instruction and registers
        rv1 = 10;
        rv2 = 15;
        #1 display_state();				// Display Current State/Results
		if (imm == iaddr_val)			// Result should be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");
        #5
        rv2 = -15;						// Set new register values
        #1 display_state();				// Display Current State/Results	
		if (imm != iaddr_val)			// Result shoud NOT be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");


        #5;
        display_b_txt("Test 4: BGE");	// Testing BGE
        $cast(idata[14:12], BGE);		// Set instruction and registers
        rv1 = 10;
        rv2 = -15;
        #1 display_state();				// Display Current State/Results
		if (imm == iaddr_val)			// Result should be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");
        #5
        rv2 = 15;						// Set new register values
        #1 display_state();				// Display Current State/Results
		if (imm != iaddr_val)			// Result should not be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");


        #5;
        display_b_txt("Test 5: BGEU");	// Testing BGEU
        $cast(idata[14:12], BGEU);		// Set instruction and registers
        rv1 = 10;
        rv2 = 5;	
        #1 display_state();				// Display Current State/Results
		if (imm == iaddr_val)			// Result should be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");


        #5;
        display_b_txt("Test 6: BLTU");	//Testing BLTU
        $cast(idata[14:12], BLTU);		// Set instruction and registers
        rv1 = 10;
        rv2 = 5;
        #1 display_state();				// Display Current State/Results
		if (imm != iaddr_val)			// Result should not be equal
			display_pass("PASS");
		else 
			display_pass("FAIL");
        
		
        #5; $finish;					// Stimulus End
    end
endmodule