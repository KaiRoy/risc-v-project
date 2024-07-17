/****************************************************
** RISC-V_L_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 7/13/2024
** Description: Testbench for the RISC-V_B_instr.sv file (WIP)
****************************************************/
`timescale 1ns / 1ps
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
	logic [31:0] drdata;
	logic [31:0] daddr;
    logic signed [31:0] imm, rv1, rv2;

    // Outputs
    logic [31:0] iaddr_val;
	logic [31:0] rd;

	// Interface
    Instr_IO bus(.*);

    // Aliases
    assign bus.idata = idata;
	assign bus.drdata = drdata;
    assign bus.iaddr = iaddr;
	assign bus.daddr = daddr;
    assign bus.imm = imm;
    assign bus.rv1 = rv1;
    assign bus.rv2 = rv2;

    assign rd = bus.regdata_L;

	// Variables
    l_func func;
    assign func = l_func'(idata[14:12]);

	L_type iDUT(bus.L_type_io_ports);

	// Display System
    function void display_state;
        $display("Instruction: %0s\naddr = %8h\tdata = %8h\trd = %8h\n", 
        func.name(), daddr, drdata, rd);
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
		rd 		= 0;
    end

    // Initial block for stimulus
    initial begin
        #10 // Test case 1: LB
		display_b_txt("Test 1: LB");
        $cast(idata[14:12], LB); // Set opcode to LB
        daddr 	= 8'h00100002; // Set data address
        drdata 	= 8'hf1f2f3f4; // Set data in memory

        #1; // Wait for a moment

		display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");
	
		//Test case 2: for LB
		display_b_txt("Test 2: LB");
		drdata = 8'h1f2f3f4f;
        #1; // Wait for a moment

        // Display results	
		display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");
		

        #10 // Test case 2: LH
		display_b_txt("Test 3: LH");
        $cast(idata[14:12], LH); // Set opcode to LH

        #1; // Wait for a moment

        // Display results
        display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");

		#10 // Test case 3: LW
        display_b_txt("Test 4: LW");
        $cast(idata[14:12], LW); // Set opcode to LW

        #1; // Wait for a moment

        // Display results
        display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");
		
		#10 // Test case 4: LBU
        display_b_txt("Test 5: LBU");
        $cast(idata[14:12], LBU); // Set opcode to LBU

        #1; // Wait for a moment

        // Display results
        display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");
		
		#10 // Test case 5: LHU
        display_b_txt("Test 6: LHU");
        $cast(idata[14:12], LH); // Set opcode to LHU

        #1; // Wait for a moment

        // Display results
        display_state(); // Display results
		// if (imm == iaddr_val)
		// 	display_pass("PASS");
		// else 
		// 	display_pass("FAIL");

        // End simulation

		#5;
        $finish;
    end
endmodule : tb