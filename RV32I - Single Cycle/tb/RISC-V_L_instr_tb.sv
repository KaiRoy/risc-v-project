/////

module L_type_tb;

    // Inputs
    logic [31:0] instr;
    logic [31:0] daddr;
    logic [31:0] drdata;

    // Outputs
    logic [31:0] out;

	L_type DUT(instr, daddr, drdata, out);

    // Initial block for stimulus
    initial begin
        // Test case 1: LB
        instr = 32'b00000000_00000000_00000000_00000000; // Set opcode to LB
        daddr = 32'b00000000_00010000_00000000_00000010; // Set data address
        drdata = 32'b11111111_11111111_11111111_11110000; // Set data in memory

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);
	
		//Testcase for LB
		drdata = 32'b11111111_01111111_11111111_11110000; // Set data in memory

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);		
		

        // Test case 2: LH
        instr = 32'b01000000_00000000_0000_1000_00000000; // Set opcode to LH

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);

		// Test case 3: LW
        instr = 32'b00000000_00000000_0001_0000_00000000; // Set opcode to LW

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);
		
		// Test case 4: LBU
        instr = 32'b00000000_00000000_0010_0000_00000000; // Set opcode to LBU

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);
		
		// Test case 5: LHU
        instr = 32'b00000000_00000000_0010_1000_00000000; // Set opcode to LHU

        #10; // Wait for a moment

        // Display results
        $display("Result = %h", out);

        // End simulation
        $finish;
    end
endmodule