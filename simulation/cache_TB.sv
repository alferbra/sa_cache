`timescale 1ns/1ps

`include "../cache_definition.sv"
import cache_definition::*;

module cache_TB();

	bit rst, clk;

    cache_to_cpu_type cache_to_cpu;
	cpu_to_cache_type cpu_to_cache;

    bit CE_N;
    bit OE_N;
    bit WE_N;
    bit LB_N;
    bit UB_N;
    bit [19:0] mem_addr;
    wire [15:0] mem_data;

    bit [9:0] ROM_addr;
    bit [36:0] ROM_data;

    assign cpu_to_cache.data = ROM_data[15:0];
    assign cpu_to_cache.addr = ROM_data[35:16];
    assign cpu_to_cache.rw = ROM_data[36];
    assign cpu_to_cache.valid = '1;

    initial begin	
	    clk=1'b0;
		forever #5 clk = ~clk;
	end

    initial begin 
        rst = '0;
        #35
        rst = '1;


        while (1) begin
            @(posedge clk)
                if (rst && !cache_to_cpu.stopped)
                    ROM_addr = ROM_addr + 1'b1;
        end
    end


    top_memory_hierarchy top_memory_hierarchy_inst (
        .clk (clk),
        .rst (rst),
        .cpu_to_cache (cpu_to_cache),
        .cache_to_cpu (cache_to_cpu),
        .CE_N (CE_N),
        .OE_N (OE_N),
        .WE_N (WE_N),
        .LB_N (LB_N),
        .UB_N (UB_N),
        .mem_addr (mem_addr),
        .mem_data (mem_data)
    );

    sram sram_inst (
        .addr (mem_addr),
        .CE_N (CE_N),
        .OE_N (OE_N),
        .WE_N (WE_N),
        .LB_N (LB_N),
        .UB_N (UB_N),
        .data (mem_data)
    );

    ROM_asynch ROM_asynch_inst (
        .address (ROM_addr),
        .dout (ROM_data)
    );

endmodule
