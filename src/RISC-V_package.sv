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
    } op_code;

	enum logic [4:0] { //instr[30, 25, 14:12]
		ADD  = 5'b00000,
		SUB  = 5'b10000,
		SLL  = 5'b00001,
		SLT  = 5'b00010,
		SLTU = 5'b00011,
		XOR  = 5'b00100,
		SRL  = 5'b00101,
		SRA  = 5'b10101,
		OR   = 5'b00110,
		AND  = 5'b00111
    } r_func;

    enum logic [4:0] { //instr[30, 25, 14:12]
        MUL    = 5'b01000,
        MULH   = 5'b01001,
        MULHSU = 5'b01010,
        MULHU  = 5'b01011,
        DIV    = 5'b01100,
        DIVU   = 5'b01101,
        REM    = 5'b01110,
        REMU   = 5'b01111
    } m_func;

endpackage