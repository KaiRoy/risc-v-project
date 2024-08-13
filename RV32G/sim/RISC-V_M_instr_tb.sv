/****************************************************
** RISC-V_M_instr_tb.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 11/20/2023
** Description: Testbench for the RISC-V_M_instr.sv file (WIP)
****************************************************/
`timescale 1ns / 1ps
import riscv_pkg::*;

module tb();
    // Interface
    Instr_IO bus ();

    // Inputs
    reg [31:0] idata;
    logic [31:0] iaddr;
    logic signed [31:0] imm, rv1, rv2;

    // Outputs
    logic [31:0] iaddr_val;

    // Aliases
    assign bus.idata = idata;
    assign bus.iaddr = iaddr;
    assign bus.imm = imm;
    assign bus.rv1 = rv1;
    assign bus.rv2 = rv2;

    assign iaddr_val = bus.iaddr_val;

    // Variables
    m_func func;
    assign func = m_func'({idata[30], idata[25],idata[14:12]});

    // Instantiate the module
    B_type iDUT (bus);

    // Display System           // Need to Modify Display Systems
    function void display_state;
        $display("Current PC: %8h\nBranch Instruction: %0s\nimm = %h\trv1 = %d\trv2 = %d\nNext PC: %8h\n", 
        iaddr, func.name(), imm, rv1, rv2, iaddr_val);
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
        display_b_txt("Test 1: MUL");
        $cast({idata[30], idata[25],idata[14:12]}, MUL);
        rv1 = 10;
        rv2 = 10;
        #1 display_state();
        #10
        rv1 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 2: MULH");
        $cast({idata[30], idata[25],idata[14:12]}, MULH);
        rv1 = 10;
        rv2 = 10;
        #1 display_state();
        #10
        rv1 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 3: MULHSU");
        $cast({idata[30], idata[25],idata[14:12]}, MULHSU);
        rv1 = 10;
        rv2 = 15;
        #1 display_state();
        #5
        rv2 = -15;
        #1 display_state();

        #5;
        display_b_txt("Test 4: MULHU");
        $cast({idata[30], idata[25],idata[14:12]}, MULHU);
        rv1 = 10;
        rv2 = -15;
        #1 display_state();
        #5
        rv2 = 15;
        #1 display_state();

        #5;
        display_b_txt("Test 5: DIV");
        $cast({idata[30], idata[25],idata[14:12]}, DIV);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 6: DIVU");
        $cast({idata[30], idata[25],idata[14:12]}, DIVU);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 7: REM");
        $cast({idata[30], idata[25],idata[14:12]}, REM);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();

        #5;
        display_b_txt("Test 8: REMU");
        $cast({idata[30], idata[25],idata[14:12]}, REMU);
        rv1 = 10;
        rv2 = 5;
        #1 display_state();
        
        #5
        $finish;
    end
endmodule