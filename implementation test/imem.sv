// `timescale 1ns / 1ps
`timescale 1ns / 1ns

//IMEM module
    
module imem(Instr_IO_cpu_sig imem_if);

logic [31:0] iaddr;
wire [31:0] idata;
assign iaddr=imem_if.iaddr;
assign imem_if.idata=idata;

    logic [31:0] i_arr[0:31];
    initial begin
		$readmemb("imem1_ini.mem",i_arr);
		//$readmemh("imem5_ini.mem",i_arr);
	end

    assign idata = i_arr[iaddr[31:2]];
endmodule