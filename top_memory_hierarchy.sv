import cache_definition::*;

module top_memory_hierarchy (
    input bit clk,
    input bit rst,
    input cpu_to_cache_type cpu_to_cache,
    output cache_to_cpu_type cache_to_cpu,
    output bit CE_N,
    output bit OE_N,
    output bit WE_N,
    output bit LB_N,
    output bit UB_N,
    output bit [19:0] mem_addr,
    inout [15:0] mem_data
);

    //Cache <-> Memory controller signals
    cache_to_mem_type cache_to_mem;
    mem_to_cache_type mem_to_cache;
    
    sram_controller #(.rw_cycles(2)) sram_controller_inst(
        .clk (clk),
        .rst (rst),
        .cache_to_mem (cache_to_mem),
        .mem_to_cache (mem_to_cache),
        .CE_N (CE_N),
        .OE_N (OE_N),
        .WE_N (WE_N),
        .LB_N (LB_N),
        .UB_N (UB_N),
        .addr (mem_addr),
        .data (mem_data)
    );

    sa_cache_controller sa_cache_controller_inst (
        .clk (clk),
        .rst (rst),
        .cpu_to_cache (cpu_to_cache),
        .mem_to_cache (mem_to_cache),
        .cache_to_mem (cache_to_mem),
        .cache_to_cpu (cache_to_cpu)
    );

endmodule