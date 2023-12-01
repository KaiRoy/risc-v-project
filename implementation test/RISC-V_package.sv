/****************************************************
** RISC-V_package.sv
** Author: Kai Roy, 
** Version: 1.0
** Date: 11/20/2023
** Description: Package file containing user-defined vars
** enums, structs, etc for the RISC-V Processor
****************************************************/
package riscv_pkg;
    typedef enum logic[2:0] {
        BEQ  = 3'b000,
        BNE  = 3'b001,
        BLT  = 3'b100,
        BGE  = 3'b101,
        BGEU = 3'b110,
        BLTU = 3'b111
    } branch_instr;

    typedef enum logic[6:0] {
        RTYPE = 7'b0110011,
        ITYPE = 7'b0010011,
        LTYPE = 7'b0000011,
        STYPE = 7'b0100011,
        BTYPE = 7'b1100011,
        JALR  = 7'b1100111,
        JAL   = 7'b1101111,
        AUIPC = 7'b0010111,
        LUI   = 7'b0110111
    } op_type;

enum logic [3:0] {rs0=4'b0000,rs1=4'b1000,rs2=4'b0001,rs3=4'b0010,rs4=4'b0011,rs5=4'b0100,rs6=4'b0101,rs7=4'b1101,rs8=4'b0110,rs9=4'b0111} OP_CODE_R;
endpackage