import Ins_def::*;

module CPU (signal_interface_cpu CPU_io_signals);


Instr_IO instrction ();

R_type r_ins (instrction.R_type_io_ports);
I_type i_ins (instrction.I_type_io_ports);
L_type l_ins (instrction.L_type_io_ports);
S_type s_ins (instrction.S_type_io_ports);
B_type b_ins (instrction.B_type_io_ports);

endmodule