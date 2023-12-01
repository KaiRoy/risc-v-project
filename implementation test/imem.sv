`timescale 1ns / 1ps

//IMEM module
    
module imem(Instr_IO_cpu_sig imem_if);

logic [31:0] iaddr;
wire [31:0] idata;
assign iaddr=imem_if.iaddr;
assign imem_if.idata=idata;

    logic [31:0] i_arr[0:31];
    //initial begin
		//$readmemh("imem1_ini.mem",i_arr);
		//$readmemh("imem5_ini.mem",i_arr);
	 //end
	 assign i_arr[0]=32'h03E00213;
    assign idata = i_arr[iaddr[31:2]];
endmodule