//--------------------------------------------------------------------------------------------

// IS61WV102416ALL IS61WV102416BLL IS64WV102416BLL 1M x 16 ASYNCHRONOUS STATIC RAM MODEL

//--------------------------------------------------------------------------------------------

`timescale 1ns/1ps

module sram (
	// INPUT PORTS
	input bit [19:0] addr,
	input bit CE_N,
	input bit OE_N, 
	input bit WE_N,
	input bit UB_N,
	input bit LB_N,
	// INOUT PORT
	inout [15:0] data
	);
	
	// INTERNAL SIGNALS
	reg [15:0] mem [0:1048575];
	reg [7:0] lower_dout;
	reg [15:8] upper_dout;
	
	assign data [15:8] = (!CE_N && !OE_N && !UB_N && WE_N) ? upper_dout : 'z;
	assign data [7:0] = (!CE_N && !OE_N && !LB_N && WE_N) ? lower_dout : 'z;
	
	
	// ----------------------------- Write Mode ---------------------------------
	
	always @ (*) begin
	
		#9
		if (!WE_N && !CE_N && !UB_N)
			mem [addr][15:8] = data [15:8];
		
		if (!WE_N && !CE_N && !LB_N)
			mem [addr][7:0] = data [7:0];
	
	end

	
	
	// ----------------------------- Read Mode ---------------------------------  
	
	always @ (*) begin

		#20
		if (WE_N && !CE_N && !OE_N && !UB_N)
			upper_dout = mem [addr][15:8];
			
		if (WE_N && !CE_N && !OE_N && !LB_N)		
			lower_dout = mem [addr][7:0];
			
	end
	
endmodule