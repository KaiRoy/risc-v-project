`timescale 1ns / 1ns
import riscv_pkg::*;

module CPU (Instr_IO_cpu_sig instr);
	

	always_ff @(posedge instr.clk, posedge instr.reset) begin
        if (instr.reset)       //Other functions for reset ????
            instr.iaddr <= 0;
        else
            instr.iaddr <= instr.pc;
    end 


    always_comb     
    begin
        case(op_code'(instr.idata[6:0]))
            RTYPE: 	begin	//R type instructions
                instr.rd = instr.idata[11:7];
                instr.rs1 = instr.idata[19:15];
                instr.rs2 = instr.idata[24:20];
                instr.wer = 1;
                instr.we = 4'b0;
                instr.regdata = instr.regdata_R;
				instr.pc = instr.iaddr+4;
            end
            ITYPE:	begin	//I type instructions
                instr.rd = instr.idata[11:7];
                instr.rs1 = instr.idata[19:15]; 
                instr.imm = {{20{instr.idata[31]}},instr.idata[31:20]};
                instr.wer=1;
                instr.we=4'b0;
                instr.regdata = instr.regdata_I;
					 instr.pc = instr.iaddr+4;
            end
            LTYPE:	begin	//L type instructions
                instr.rd = instr.idata[11:7];
                instr.rs1 = instr.idata[19:15]; 
                instr.imm = {{20{instr.idata[31]}},instr.idata[31:20]};
                instr.wer=1;
                instr.we=4'b0;
                instr.daddr = instr.rv1+instr.imm;    
                instr.regdata = instr.regdata_L;
				instr.pc = instr.iaddr+4;
            end
            STYPE:	begin	//S type instructions
                instr.rs1 = instr.idata[19:15];
                instr.rs2 = instr.idata[24:20];
                instr.imm = {{20{instr.idata[31]}},instr.idata[31:25],instr.idata[11:7]};
                instr.wer=0;
                instr.daddr = instr.rv1+instr.imm;
					 case(instr.idata[14:12])
					 3'b000: instr.dwdata = {instr.rv2[7:0],instr.rv2[7:0],instr.rv2[7:0],instr.rv2[7:0]};
					 3'b001: instr.dwdata = {instr.rv2[15:0],instr.rv2[15:0]};
					 3'b010: instr.dwdata = instr.rv2;
					 endcase
                instr.we = instr.we_S;
					 instr.pc = instr.iaddr+4;
            end
			BTYPE:	begin	//B type instructions
				instr.rs1 = instr.idata[19:15];
				instr.rs2 = instr.idata[24:20];
				instr.imm = {{20{instr.idata[31]}},instr.idata[31],instr.idata[7],instr.idata[30:25],instr.idata[11:8],1'b0};
				instr.wer=0;
				instr.we=4'b0;
				instr.pc = instr.iaddr_val;
			end
			JALR:	begin //JALR instruction
				instr.rs1 = instr.idata[19:15];
				instr.rd = instr.idata[11:7];
				instr.imm = {{20{instr.idata[31]}},instr.idata[31:20]};
				instr.wer = 1;
				instr.we = 4'b0;
				instr.regdata = instr.iaddr+4;
				instr.pc = (instr.rv1+instr.imm)&32'hfffffffe;
			end
			JAL:	begin	//JAL instruction
				instr.rd = instr.idata[11:7];
				instr.imm = {{11{instr.idata[31]}},instr.idata[31],instr.idata[19:12],instr.idata[20],instr.idata[30:21],1'b0};
				instr.pc = (instr.iaddr+instr.imm);
				instr.wer = 1;
				instr.we = 4'b0;
				instr.regdata = instr.iaddr+4;
			end
			AUIPC:	begin	//AUIPC
				instr.rd = instr.idata[11:7];
				instr.imm = {instr.idata[31:12],12'b0};
				instr.wer = 1;
				instr.we = 4'b0;
				instr.regdata = instr.iaddr+instr.imm;
				instr.pc = instr.iaddr+4;
			end
			LUI: begin	//LUI
				instr.rd = instr.idata[11:7];
				instr.imm = {instr.idata[31:12],12'b0};
				instr.wer=1;
				instr.we=4'b0;
				instr.regdata = instr.imm;
				instr.pc = instr.iaddr+4;
			end
		endcase
    end



R_type r_ins (instr.R_type_io_ports);
I_type i_ins (instr.I_type_io_ports);
L_type l_ins (instr.L_type_io_ports);
S_type s_ins (instr.S_type_io_ports);
B_type b_ins (instr.B_type_io_ports);


imem im2_ins(instr.imem_io_ports);
dmem d1_ins (instr.dmem_io_ports);
regfile r1  (instr.regfile_io_ports);

endmodule
