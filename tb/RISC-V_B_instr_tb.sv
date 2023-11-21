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
    signed logic [31:0] imm, rv1, rv2

    // Outputs
    logic [3:0] iaddr_val;

    // Instantiate the module
    B_type iDUT (
        .instr(idata),
        .rs1(rv1),
        .rs2(rv2),
        .pc(iaddr_val),
        .*
    );

    // Display System
    always @(iaddr_val) begin
        $display("
        Current PC: %8h\n
        Branch Instruction: %0s\n
        imm = %d\trv1 = %d\trv2 = %d\n
        Next PC: %8h\n", 
        iaddr, branch_instr'(idata[14:12]).name(), imm, rv1, rv2, iaddr_val);
    end

    // Initial Values
    initial begin
        iaddr = 0;
        imm =   'hFF;
        idata = 0;
        rv1 =   0;
        rv2 =   0;
    end

    // Test Stimulus
    initial begin
        #5;
        $cast(idata[14:12], branch_instr.BEQ);
        rv1          = 10;
        rv2          = 10;
        #5
        rv1          = 5;

        #5;
        $cast(idata[14:12], branch_instr.BNE);
        rv1          = 10;
        rv2          = 10;
        #5
        rv1          = 5;

        #5;
        $cast(idata[14:12], branch_instr.BLT);
        rv1          = 10;
        rv2          = 5;
        #5
        rv2          = 15;

        #5;
        $cast(idata[14:12], branch_instr.BGE);
        rv1          = 10;
        rv2          = 5;
        #5
        rv2          = 15;

        #5;
        $cast(idata[14:12], branch_instr.BGEU);
        rv1          = ;
        rv2          = ;

        #5;
        $cast(idata[14:12], branch_instr.BLTU);
        rv1          = ;
        rv2          = ;

    end
endmodule