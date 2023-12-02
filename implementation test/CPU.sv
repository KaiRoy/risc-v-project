// `timescale 1ns / 1ps
`timescale 1ns / 1ns
import Ins_def::*;
import riscv_pkg::*;

module CPU (
	input logic clk,
    input logic reset,
	output logic [31:0] iaddr,  //Stores current Program counter value
	output logic [31:0]  pc,     //Stores the value that is to be assigned in the next clk cycle to Program counter
    output logic [31:0] x31
);
	Instr_IO_cpu_sig instruction(.*);


	



	always_ff @(posedge clk, posedge reset) begin
        if (reset)       //Other functions for reset ????
            instruction.iaddr <= 0;
        else
            instruction.iaddr <= instruction.pc;
    end 


    always_comb     
    begin
        case(op_type'(instruction.idata[6:0]))
            RTYPE:      //R type instructions
            begin
                instruction.rd = instruction.idata[11:7];
                instruction.rs1 = instruction.idata[19:15];
                instruction.rs2 = instruction.idata[24:20];
                instruction.wer = 1;
                instruction.we = 4'b0;
                instruction.regdata = instruction.regdata_R;
				instruction.pc = instruction.iaddr+4;
            end
            ITYPE:     //I type instructions
            begin
                instruction.rd = instruction.idata[11:7];
                instruction.rs1 = instruction.idata[19:15]; 
                instruction.imm = {{20{instruction.idata[31]}},instruction.idata[31:20]};
                instruction.wer=1;
                instruction.we=4'b0;
                instruction.regdata = instruction.regdata_I;
					 instruction.pc = instruction.iaddr+4;
            end
            LTYPE:     //L type instructions
            begin
                instruction.rd = instruction.idata[11:7];
                instruction.rs1 = instruction.idata[19:15]; 
                instruction.imm = {{20{instruction.idata[31]}},instruction.idata[31:20]};
                instruction.wer=1;
                instruction.we=4'b0;
                instruction.daddr = instruction.rv1+instruction.imm;    
                instruction.regdata = instruction.regdata_L;
				instruction.pc = instruction.iaddr+4;
            end
            STYPE:     //S type instructions
            begin
                instruction.rs1 = instruction.idata[19:15];
                instruction.rs2 = instruction.idata[24:20];
                instruction.imm = {{20{instruction.idata[31]}},instruction.idata[31:25],instruction.idata[11:7]};
                instruction.wer=0;
                instruction.daddr = instruction.rv1+instruction.imm;
					 case(instruction.idata[14:12])
					 3'b000: instruction.dwdata = {instruction.rv2[7:0],instruction.rv2[7:0],instruction.rv2[7:0],instruction.rv2[7:0]};
					 3'b001: instruction.dwdata = {instruction.rv2[15:0],instruction.rv2[15:0]};
					 3'b010: instruction.dwdata = instruction.rv2;
					 endcase
                instruction.we = instruction.we_S;
					 instruction.pc = instruction.iaddr+4;
            end
			BTYPE:		//B type instructions
			begin
				instruction.rs1 = instruction.idata[19:15];
				instruction.rs2 = instruction.idata[24:20];
				instruction.imm = {{20{instruction.idata[31]}},instruction.idata[31],instruction.idata[7],instruction.idata[30:25],instruction.idata[11:8],1'b0};
				instruction.wer=0;
				instruction.we=4'b0;
				instruction.pc = instruction.iaddr_val;
			end
			JALR:		//JALR instruction
			begin
				instruction.rs1 = instruction.idata[19:15];
				instruction.rd = instruction.idata[11:7];
				instruction.imm = {{20{instruction.idata[31]}},instruction.idata[31:20]};
				instruction.wer = 1;
				instruction.we = 4'b0;
				instruction.regdata = instruction.iaddr+4;
				instruction.pc = (instruction.rv1+instruction.imm)&32'hfffffffe;
			end
			JAL:		//JAL instruction
			begin
				instruction.rd = instruction.idata[11:7];
				instruction.imm = {{11{instruction.idata[31]}},instruction.idata[31],instruction.idata[19:12],instruction.idata[20],instruction.idata[30:21],1'b0};
				instruction.pc = (instruction.iaddr+instruction.imm);
				instruction.wer = 1;
				instruction.we = 4'b0;
				instruction.regdata = instruction.iaddr+4;
			end
			AUIPC:		//AUIPC
			begin
				instruction.rd = instruction.idata[11:7];
				instruction.imm = {instruction.idata[31:12],12'b0};
				instruction.wer = 1;
				instruction.we = 4'b0;
				instruction.regdata = instruction.iaddr+instruction.imm;
				instruction.pc = instruction.iaddr+4;
			end
			LUI:		//LUI
			begin
				instruction.rd = instruction.idata[11:7];
				instruction.imm = {instruction.idata[31:12],12'b0};
				instruction.wer=1;
				instruction.we=4'b0;
				instruction.regdata = instruction.imm;
				instruction.pc = instruction.iaddr+4;
			end
		endcase
    end



R_type r_ins (instruction.R_type_io_ports);
I_type i_ins (instruction.I_type_io_ports);
L_type l_ins (instruction.L_type_io_ports);
S_type s_ins (instruction.S_type_io_ports);
B_type b_ins (instruction.B_type_io_ports);

imem im2_ins(instruction.imem_io_ports );
dmem d1_ins (instruction.dmem_io_ports);
regfile r1  (instruction.regfile_io_ports);

endmodule