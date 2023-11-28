/****************************************************
** RISC-V_B_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 11/20/2023
** Description: Testbench for the RISC-V_B_instr.sv file (WIP)
****************************************************/
`timescale 1ns / 1ps
import riscv_pkg::*;

module tb();
    // Inputs
    logic [31:0] idata;
    logic [31:0] iaddr;
    logic signed [31:0] imm, rv1, rv2;

    // Outputs
    logic [31:0] iaddr_val;

    // Variables
    branch_instr branch;
    assign branch = branch_instr'(idata[14:12]);

    // Instantiate the module
    B_type iDUT (
        .instr(idata),
        .rs1(rv1),
        .rs2(rv2),
        .pc(iaddr_val),
        .*
    );

    // Display System
    function void display_state;
        $display("Current PC: %8h\nBranch Instruction: %0s\nimm = %h\trv1 = %d\trv2 = %d\nNext PC: %8h\n", 
        iaddr, branch.name(), imm, rv1, rv2, iaddr_val);
    endfunction
    function void display_b_txt(string str);
        $display("%c[1;34m",27);
        $write(str);
        $display("%c[0m\n",27);
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
        display_b_txt("Test 1: BEQ");
        $cast(idata[14:12], BEQ);
        rv1 = 10;
        rv2 = 10;
        #1 display_state();
        #10
        rv1 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 2: BNE");
        $cast(idata[14:12], BNE);
        rv1 = 10;
        rv2 = 10;
        #1 display_state();
        #10
        rv1 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 3: BLT");
        $cast(idata[14:12], BLT);
        rv1 = 10;
        rv2 = 15;
        #1 display_state();
        #5
        rv2 = -15;
        #1 display_state();

        #5;
        display_b_txt("Test 4: BGE");
        $cast(idata[14:12], BGE);
        rv1 = 10;
        rv2 = -15;
        #1 display_state();
        #5
        rv2 = 15;
        #1 display_state();

        #5;
        display_b_txt("Test 5: BGEU");
        $cast(idata[14:12], BGEU);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 6: BLTU");
        $cast(idata[14:12], BLTU);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();
        
        #5
        $finish;
    end
endmodule